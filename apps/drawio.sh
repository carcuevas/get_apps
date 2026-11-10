PKG=drawio
EXEC_FILE=drawio.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest jgraph drawio-desktop; }

url_linux_amd64() { echo "https://github.com/jgraph/drawio-desktop/releases/download/v${VERSION}/drawio-x86_64-${VERSION}.AppImage"; }
url_linux_arm64() { echo "https://github.com/jgraph/drawio-desktop/releases/download/v${VERSION}/drawio-aarch64-${VERSION}.AppImage"; }
# macOS: DMG available — TODO
