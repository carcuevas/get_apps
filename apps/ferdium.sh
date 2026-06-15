PKG=ferdium
EXEC_FILE=ferdium.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest ferdium ferdium-app; }

url_linux_amd64() { echo "https://github.com/ferdium/ferdium-app/releases/download/v${VERSION}/Ferdium-linux-Portable-${VERSION}-x86_64.AppImage"; }
url_linux_arm64() { echo "https://github.com/ferdium/ferdium-app/releases/download/v${VERSION}/Ferdium-linux-Portable-${VERSION}-arm64.AppImage"; }
# macOS: DMG available from GitHub releases — TODO
