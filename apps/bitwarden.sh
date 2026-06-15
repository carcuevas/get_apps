PKG=bitwarden
EXEC_FILE=bitwarden
ARCHIVE_FORMAT=appimage
VERSIONED=false      # URL always fetches latest build
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true

# No get_latest — URL is always the latest build
url_linux_amd64() { echo "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=appimage"; }
# No Linux ARM64 AppImage from Bitwarden
# macOS: DMG available from vault.bitwarden.com — TODO
