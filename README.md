# get_apps

## Intro

This started when I was using Arch Linux and not trusting some AUR repos, so I grabbed the files myself from the official sources (many times straight from the official GitHub). Now the idea is to take this further and support **Linux and macOS** on both **AMD64 and ARM64** — always using official packages only, no third-party repos.

> Apps distributed as `.AppImage` are Linux-only by nature and won't be ported to macOS.

## Prerequisites

- `bash`, `wget` or `curl`
- `tar`, `unzip`
- `sudo` access

## How it works

Scripts handle downloading, extracting, symlinking, and desktop integration automatically. Some auto-fetch the latest release — no version needed:

```bash
sudo get_bitwarden.sh
sudo get_1password.sh
sudo get_logcli.sh
```

Others require a version string:

```bash
sudo get_tidal.sh 6.0.1
sudo get_terraform.sh 1.8.0
sudo get_postman.sh 11.0.0
```

Each script installs to `/opt/{app}`, creates a symlink in `/usr/local/bin`, and sets up the desktop menu entry with icon. Don't forget to add `/usr/local/bin` to your PATH if it's not there already:

```bash
export PATH=$PATH:/usr/local/bin   # add to ~/.bashrc or ~/.zshrc
```

## Platform & Architecture Support

| Application        | Linux AMD64 | Linux ARM64 | macOS AMD64 | macOS ARM64 |
|--------------------|:-----------:|:-----------:|:-----------:|:-----------:|
| 1Password          | ✅          | 🔜          | 🔜          | 🔜          |
| Bitwarden          | ✅ AppImage | —           | 🔜          | 🔜          |
| Brave              | ✅          | 🔜          | 🔜          | 🔜          |
| Brave Nightly      | ✅          | 🔜          | 🔜          | 🔜          |
| Darktable          | ✅          | 🔜          | 🔜          | 🔜          |
| Draw.io Desktop    | ✅          | 🔜          | 🔜          | 🔜          |
| Ferdium            | ✅ AppImage | —           | 🔜          | 🔜          |
| Logcli (Grafana)   | ✅          | 🔜          | 🔜          | 🔜          |
| Packer             | ✅          | 🔜          | 🔜          | 🔜          |
| Postman            | ✅          | 🔜          | 🔜          | 🔜          |
| Terraform          | ✅          | 🔜          | 🔜          | 🔜          |
| Tidal Hi-Fi        | ✅ AppImage | —           | —           | —           |
| VS Code            | ✅          | 🔜          | 🔜          | 🔜          |
| WinBox             | ✅          | 🔜          | 🔜          | 🔜          |

✅ = working · 🔜 = planned · — = not applicable (AppImage / no official package)
