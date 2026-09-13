PKG=ferdium
EXEC_FILE=ferdium
ARCHIVE_FORMAT=appimage   # default for amd64; arm64 URL ends in .deb and is auto-detected
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true # only present in the arm64 .deb layout; skipped for the amd64 AppImage

get_latest() { gh_latest ferdium ferdium-app; }

url_linux_amd64() { echo "https://github.com/ferdium/ferdium-app/releases/download/v${VERSION}/Ferdium-linux-Portable-${VERSION}-x86_64.AppImage"; }
# No arm64 AppImage build is published — only a .deb, so we extract that instead.
url_linux_arm64() { echo "https://github.com/ferdium/ferdium-app/releases/download/v${VERSION}/Ferdium-linux-${VERSION}-arm64.deb"; }
# macOS: DMG available from GitHub releases — TODO

# The .deb's data.tar.* contains the app under ./opt/Ferdium — pull that out
# and use it directly as DEST_DIR (only reached for the deb/arm64 path).
post_extract() {
    local extract_dir="$1" dest_dir="$2"
    rm -rf "$dest_dir"
    mv "${extract_dir}/opt/Ferdium" "$dest_dir"
}
