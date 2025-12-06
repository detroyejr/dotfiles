"""Snippets LSP

A light-weight LSP server that just does snippets.
"""

import abc
import argparse
import dataclasses
import json
import logging
import pathlib
import sys
from typing import Any, Generator

logger = logging.Logger(__name__)


class MessageEncoder(json.JSONEncoder):
    def default(self, o):
        try:
            iterable = iter(o)
        except TypeError:
            pass
        else:
            return list(iterable)[0]
        return super().default(o)


class Message(abc.ABC):
    def __init__(self, id=None) -> None:
        self.jsonrpc: str = "2.0"
        self._msg_template = "Content-Length: %d\r\n\r\n%s"
        self.id = id

    def __iter__(self) -> Generator[dict[str, Any]]:
        data = self.__dict__.copy()
        del data["_msg_template"]
        yield {"jsonrpc": data.get("jsonrpc")}

    def to_message(self):
        content = json.dumps(self, cls=MessageEncoder)
        return (self._msg_template % (len(content), content)).encode()

    def send(self):
        sys.stdout.buffer.write(self.to_message())
        sys.stdout.flush()


@dataclasses.dataclass
class ResponseError:
    code: int
    message: str
    data: None


class ResponseMessage(Message):
    def __init__(self, id, result=None, error=None) -> None:
        super().__init__(self)
        self.id: int | str = id
        self.result: dict[str, str] = result
        self.error: ResponseError = error

    def __iter__(self):
        resp = {
            "jsonrpc": self.jsonrpc,
            "id": self.id,
            "result": self.result,
        }

        if self.error:
            yield resp | {"error": self.error}
        else:
            yield resp

    def __str__(self):
        content = json.dumps(self, cls=MessageEncoder)
        return self._msg_template % (len(content), content)

    def __repr__(self):
        return self.__str__()


class InitializedResult(Message):
    def __init__(self, id, snippets):
        Message.__init__(self)
        self.id = id
        self.snippets = snippets

    def __iter__(
        self,
    ):
        chars = []
        for v in self.snippets.values():
            for v in v.values():
                chars = chars + list(v.get("prefix"))
        yield {
            "jsonrpc": self.jsonrpc,
            "id": self.id,
            "result": {
                "capabilities": {
                    "textDocumentSync": {"change": 2, "openClose": True},
                    "completionProvider": {"triggerCharacters": chars},
                    "synchronization": {
                        "didChange": True,
                        "didOpen": True,
                        "didClose": True,
                    },
                },
                "serverInfo": {"name": "snippet-lsp", "version": 1.0},
            },
        }

    def __str__(self):
        content = json.dumps(self, cls=MessageEncoder)
        return self._msg_template % (len(content), content)

    def __bytes__(self):
        return str(self).encode()

    def __repr__(self):
        return str(self.__dict__)


class LSPServer:
    def __init__(self, snippet_location=None) -> None:
        self.languageId: dict[str, str] = {}
        self.snippets: dict[str, str] = {}
        self.snippet_location = pathlib.Path(snippet_location)
        if not self.snippet_location.exists():
            raise NotADirectoryError("Snippet directory does not exist.")
        for file in self.snippet_location.glob("*.json"):
            with open(file) as f:
                lang = file.name.replace(".json", "")
                self.snippets[lang] = json.load(f)

    def initialize(self):
        header, msg = self.next_message()
        self.client_data = msg

        InitializedResult(
            self.client_data.get("id"),
            self.snippets,
        ).send()

    def next_message(self):
        header, content = "", ""
        _, content_length = sys.stdin.readline().strip().split(":")
        content_length = int(content_length.strip())
        # Read the rpc data + the 2 extra line terminate characters.
        content = sys.stdin.read(content_length + 2).strip()
        if len(content) > 0:
            content = json.loads(content)
        return header, content

    def _ext(self, uri):
        return pathlib.Path.from_uri(uri).suffix.strip(".")

    def snippet_items(self):
        snippets_exists = [
            languageid in self.snippets for languageid in self.languageId
        ]
        if any(snippets_exists):
            snippets = {}
            for languageid in self.languageId.values():
                snippets = snippets | self.snippets[languageid]

            return [
                {
                    "label": x.get("prefix"),
                    "insertText": "".join(x.get("body")),
                    "kind": 15,
                }
                for x in snippets.values()
            ]

    def loop(self):
        while True:
            header, content = self.next_message()
            if content:
                match content.get("method"):
                    case "textDocument/didOpen":
                        text_document = content["params"]["textDocument"]
                        ext = self._ext(text_document["uri"])
                        self.languageId[ext] = text_document.get("languageId")
                    case "textDocument/didClose":
                        text_document = content["params"]["textDocument"]
                        self.languageId.pop(self._ext(text_document["uri"]))
                    case "textDocument/completion":
                        if not self.languageId:
                            raise NotImplementedError(
                                "LSP could not find languageId"
                            )
                        items = self.snippet_items()
                        ResponseMessage(
                            id=content.get("id"),
                            result={
                                "isIncomplete": len(items) <= 1,
                                "itemDefaults": {
                                    "insertTextFormat": 2,
                                },
                                "items": items,
                            },
                        ).send()
                    case _:
                        pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--version",
        action=argparse.BooleanOptionalAction,
        default=False,
    )

    parser.add_argument(
        "--snippet-dir",
        type=str,
        default="dotfiles/nvim/snippets",
    )

    args = parser.parse_args()

    if args.version:
        print("Version 1.0")
        sys.exit(0)

    server = LSPServer(args.snippet_dir)
    server.initialize()
    server.loop()
