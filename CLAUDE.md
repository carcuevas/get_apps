# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

**get_apps** is a collection of Bash scripts for installing desktop applications on Linux (and in MacOS in the future) directly from official sources — a safer alternative to AUR and other thigns. Each script in `bin/` handles one application end-to-end.

## Running and testing

No build system. The main entry point is `getapp` at the repo root:

```bash
sudo ./getapp terraform              # installs latest version automatically
sudo ./getapp terraform -v 1.8.0    # installs a specific version
./getapp list                        # list all available apps
./getapp terraform --dry-run         # show what would happen, no changes made
```

To lint:
```bash
shellcheck getapp lib/common.sh apps/*.sh
```

## Architecture

```
getapp          # single entry point — argument parsing, loads app config, calls install_app()
lib/
  common.sh     # all shared logic: platform detection, download, extract, symlinks, desktop, version helpers
  icons/        # app icons (PNG)
  *.desktop     # desktop menu entry files
  _APP_.desktop # sed template for apps without a custom .desktop
apps/
  terraform.sh  # per-app config: ~10 lines of variables + url_{os}_{arch}() functions
  ...           # one file per app
```

`getapp` sources `lib/common.sh` then the chosen `apps/{app}.sh`, detects platform, and calls `install_app()` from common.sh.

## How install_app() works

1. If `get_latest()` is defined in the app config — fetch latest version via API
2. If still no version and `VERSIONED=true` — die with "requires a version"
3. Call `url_{OS}_{ARCH}()` from app config to build the download URL; die if function missing (platform not supported)
4. Download to `/tmp/`, extract, move to `DEST_DIR`
5. If `post_extract()` defined in app config — called with `(TMP_EXTRACT, DEST_DIR)` for custom renames
6. Create versioned symlink `/opt/{pkg}` → `/opt/{pkg}_{version}` (if `VERSIONED=true`)
7. Symlink binary into `BIN_DIR`
8. Install desktop entry + chrome-sandbox perms if needed
9. If `post_install()` defined — called for any extra steps (e.g. VS Code's second `.desktop` file)

## Install paths by OS

| | Linux | macOS |
|---|---|---|
| App root | `/opt/{app}_{ver}` | `/usr/local/opt/{app}_{ver}` |
| Binary | `/usr/local/bin/{app}` | `/usr/local/bin/{app}` |
| Desktop | `/usr/share/applications/` | (skipped) |

## App config variables

| Variable | Required | Default | Notes |
|---|---|---|---|
| `PKG` | yes | — | install dir name and binary symlink name |
| `EXEC_FILE` | yes | — | actual executable filename inside install dir |
| `ARCHIVE_FORMAT` | yes | — | `tar.gz`, `zip`, or `appimage` |
| `VERSIONED` | no | `true` | `false` for always-latest apps (bitwarden, 1password) |
| `NEEDS_DESKTOP` | no | `false` | installs `.desktop` entry on Linux |
| `NEEDS_CHROME_SANDBOX` | no | `false` | sets setuid root on `chrome-sandbox` (Electron apps) |

## Adding a new app

1. Create `apps/{name}.sh` — set the variables above, define `get_latest()` (or omit if version always required), define `url_linux_amd64()` and any other supported platform functions
2. Add icon PNG to `lib/icons/{name}.png`
3. Add a custom `.desktop` file to `lib/` if the generic template isn't sufficient
4. Test: `./getapp {name} --dry-run`
