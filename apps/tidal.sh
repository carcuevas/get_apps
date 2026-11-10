PKG=tidal
EXEC_FILE=tidal.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest Mastermindzh tidal-hifi; }

# Linux AMD64 only — AppImage, no macOS package available
url_linux_amd64() { echo "https://github.com/Mastermindzh/tidal-hifi/releases/download/${VERSION}/tidal-hifi-${VERSION}.AppImage"; }
