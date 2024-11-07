#!/usr/bin/env python

"""Ark LSP

A wrapper to expose ark's lsp server to other clients.
"""

import os
import json
import random
import socket
import subprocess
import tempfile
import time

import jupyter_client


def get_open_ports(n):
    """Get an open port from a range."""
    result = set()
    while len(result) < n:
        port_is_closed = True
        while port_is_closed:
            port = random.sample(range(43000, 63000), 1)[0]
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                port_is_closed = sock.connect_ex(("127.0.0.1", port)) == 0
        result.add(port)
    return result


tempdir = tempfile.TemporaryDirectory()
connection_file = tempfile.mktemp(
    suffix=".json",
    prefix="ark-lsp-",
    dir=tempdir.name,
)

(
    control_port,
    shell_port,
    stdin_port,
    iopub_port,
    hb_port,
    lsp_port,
) = get_open_ports(6)

connection_info = {
    "control_port": control_port,
    "shell_port": shell_port,
    "stdin_port": stdin_port,
    "iopub_port": iopub_port,
    "hb_port": hb_port,
    "signature_scheme": "hmac-sha256",
    "ip": "127.0.0.1",
    "transport": "tcp",
    "key": "",
}

with open(connection_file, "w+") as tmp:
    json.dump(connection_info, tmp)

# NOTE: NixOS uses R_LIBS_SITE extensively to catalogue the list of available R
# packages in your environment. If this isn't set ark will default to using
# R_HOME which doesn't have any information about the nix store or packages
# available in your environment.
rpaths = subprocess.run(
    ["Rscript", "--silent", "-e", 'paste(.libPaths(), collapse = ":")'],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
)

os.environ.update({"R_LIBS_SITE": rpaths.stdout[4:-1].decode()})

subprocess.Popen(
    [
        "ark",
        "--connection_file",
        connection_file,
        "--log",
        "{}/kernel.log".format(tempdir.name),
    ],
    start_new_session=True,
    env=os.environ.copy(),
)

km = jupyter_client.AsyncKernelClient(
    connection_file=jupyter_client.find_connection_file(connection_file)
)
km.load_connection_file()
km.start_channels()
data = km.session.msg("comm_open")
data.update({
    "content": {
        "comm_id": "positron-lsp-bridge",
        "target_name": "positron.lsp",
        "data": {"client_address": "127.0.0.1:{}".format(lsp_port)},
    }
})
km.session.send(msg_or_type=data, stream=km.shell_channel.socket)

time.sleep(2)

print(lsp_port)
