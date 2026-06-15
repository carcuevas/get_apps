# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

**get_apps** is a collection of Bash scripts for installing desktop applications on Linux (and in MacOS in the future) directly from official sources — a safer alternative to AUR and other thigns. Each script in `bin/` handles one application end-to-end.

## No Build or Test System

There is no Makefile, package.json, or test suite. Scripts are executed directly as root. The GitHub Actions workflow (`.github/workflows/blank.yml`) is a placeholder stub — not functional.

To run a script:
```bash
sudo ./bin/get_bitwarden.sh         # no version arg needed
sudo ./bin/get_terraform.sh 1.8.0   # version required as $1
```

To lint shell scripts (if shellcheck is available):
```bash
shellcheck bin/*.sh
```

## Script Anatomy

Every script follows the same pattern:
1. Download from official source (GitHub releases or vendor CDN)
2. Extract to `/opt/{app}` or `/opt/{app}_{version}` (symlinked to `/opt/{app}`)
3. Copy icon from `lib/icons/{app}.png` to `/opt/{app}/icon.png`
4. Write a `.desktop` file to `/usr/share/applications/` (some use `lib/_APP_.desktop` as a template via `sed`)
5. Symlink binary into `/bin/` or `/usr/local/bin/`
6. Set special permissions if needed (e.g., `chrome-sandbox` for Electron apps)

## Two Download Patterns

- **Latest-version scripts** — fetch the current release automatically: `get_bitwarden.sh`, `get_1password.sh`, `get_logcli.sh`
- **Version-pinned scripts** — require a version string as `$1`: `get_terraform.sh`, `get_packer.sh`, `get_postman.sh`, `get_tidal.sh`, `get_code.sh`

## Key Paths

| Purpose | Path |
|---|---|
| Install root | `/opt/{app}` |
| CLI symlinks | `/usr/local/bin/{app}` or `/bin/{app}` |
| Desktop entries | `/usr/share/applications/{app}.desktop` |
| Icon source | `lib/icons/{app}.png` |
| Desktop template | `lib/_APP_.desktop` |

## Adding a New Application Script

Use any existing script as a reference. Key things to get right:
- Fail fast with `exit 1`/`exit 2`/`exit 3` on download/extract failures
- Use `sed` on `lib/_APP_.desktop` for the desktop entry, or write a custom one in `lib/`
- Add the app's icon as a PNG to `lib/icons/`
- Use `/opt/{app}` as the install prefix; symlink to `/opt/{app}_{version}` if versioned
- For Electron apps: `chmod 4755 /opt/{app}/chrome-sandbox` after install
