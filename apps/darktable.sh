PKG=darktable
EXEC_FILE=darktable.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() {
    # Tags are "release-X.Y.Z" — strip the prefix
    curl -s "https://api.github.com/repos/darktable-org/darktable/releases/latest" \
        | grep '"tag_name"' | head -1 | cut -d'"' -f4 | sed 's/^release-//'
}

url_linux_amd64() { echo "https://github.com/darktable-org/darktable/releases/download/release-${VERSION}/Darktable-${VERSION}-x86_64.AppImage"; }
url_linux_arm64() { echo "https://github.com/darktable-org/darktable/releases/download/release-${VERSION}/Darktable-${VERSION}-aarch64.AppImage"; }
# macOS: DMG available — TODO
