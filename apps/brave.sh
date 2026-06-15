PKG=brave
EXEC_FILE=brave
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true

get_latest() { gh_latest brave brave-browser; }

url_linux_amd64() { echo "https://github.com/brave/brave-browser/releases/download/v${VERSION}/brave-browser-${VERSION}-linux-amd64.zip"; }
url_linux_arm64() { echo "https://github.com/brave/brave-browser/releases/download/v${VERSION}/brave-browser-${VERSION}-linux-arm64.zip"; }
# macOS: DMG format — TODO
