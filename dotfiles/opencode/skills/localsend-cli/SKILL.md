---
name: localsend-cli
description: Use when sending files, directories, or text to nearby devices with the LocalSend command-line client.
---

# LocalSend CLI Skill

Use this skill for tasks involving `localsend-cli`, LocalSend-compatible
transfers, or sending local files and text to nearby devices.

## Before Sending

- Sending transfers data over the local network. Only send when the user has
  clearly requested the transfer.
- Confirm the intended recipient and the exact files or text if either is
  ambiguous. Do not send secrets or sensitive files unless the user explicitly
  authorizes that transfer.
- The CLI needs a terminal to work correctly. Run every CLI command through
  `script` using this form, putting the full CLI invocation in `--command`:

  ```sh
  ${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli ..." /dev/null
  ```

- Check `--help` or `send --help` with this same wrapper when options or
  behavior are unclear; CLI options can change between versions.
- Do not assume a dry-run mode or claim a transfer succeeded unless the CLI
  confirms it.

## Sending Files

`send` accepts one or more files, directories, or a mixture of both:

```sh
${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli send report.pdf photo.jpg ./project-backup" /dev/null
```

Without `--to`, the CLI presents discovered devices for interactive selection.
For a direct send, use the recipient's exact, unique device alias or IP address:

```sh
${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli send --to 'Cute Tomato' report.pdf" /dev/null
${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli send --to 192.168.27.26 report.pdf" /dev/null
```

Aliases must uniquely identify a discovered device. An IP address is probed on
LocalSend's default port, `53317`. If the recipient cannot be identified
confidently, ask rather than guessing.

Directories are collected recursively. The chosen directory root and nested
paths are preserved on the receiving device; empty directories are not
transferred.

## Sending Text

Text sending requires `--text` and a recipient. Use `-` to read UTF-8 text from
stdin:

```sh
${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli send --to 'Cute Tomato' --text 'https://localsend.org'" /dev/null
printf '%s' 'Hello' | ${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli send --to 'Cute Tomato' --text -" /dev/null
```

For stdin, one trailing line break is dropped. Text over 64 KB is sent as a
`.txt` file instead. Stdin must be UTF-8 and no larger than 16 MB; send other
data as a file.

## Troubleshooting

- If discovery fails, confirm both devices are on a network that permits
  device-to-device traffic. Check VPN or firewall restrictions and router AP
  isolation.
- Try the recipient's IP address when discovery or alias matching is the issue,
  but only when the user has identified the correct recipient.
- LocalSend commonly uses TCP and UDP port `53317`; firewall changes require
  user authorization and should be limited to what is needed.
- Report the CLI's actual error and the checks performed. Do not claim that a
  receiver accepted or saved a transfer based only on successful discovery.

## Sources

- Official CLI documentation: <https://github.com/localsend/localsend#command-line-interface>
- CLI help: `${pkgs.util-linux}/bin/script --quiet --return --command "${pkgs.localsend-cli}/bin/localsend-cli --help" /dev/null`
