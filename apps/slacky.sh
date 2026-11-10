PKG=slacky
EXEC_FILE=slacky.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest andirsun Slacky; }

# Linux ARM64 only — only an arm64 AppImage/deb/rpm are published
url_linux_arm64() { echo "https://github.com/andirsun/Slacky/releases/download/v${VERSION}/Slacky-${VERSION}-arm64.AppImage"; }
