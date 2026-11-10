PKG=bitwarden
EXEC_FILE=bitwarden
ARCHIVE_FORMAT=appimage   # default for amd64; arm64 URL ends in .tar.gz and is auto-detected
VERSIONED=false           # both archs install unversioned to /opt/bitwarden
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true

# amd64 URL is always-latest and needs no version. arm64 has no such
# always-latest link, so fetch the current desktop release tag to build one.
get_latest() {
    curl -s "https://api.github.com/repos/bitwarden/clients/releases?per_page=20" \
        | grep '"tag_name": "desktop-v' | head -1 | sed -E 's/.*"desktop-v([^"]+)".*/\1/'
}

url_linux_amd64() { echo "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=appimage"; }
# No Linux ARM64 AppImage from Bitwarden — use the arm64 tar.gz from GitHub instead.
url_linux_arm64() { echo "https://github.com/bitwarden/clients/releases/download/desktop-v${VERSION}/bitwarden_${VERSION}_arm64.tar.gz"; }
# macOS: DMG available from vault.bitwarden.com — TODO

# The arm64 tar.gz extracts flat (binary + chrome-sandbox at top level plus a
# resources/ dir) — the generic "single subdir" fallback in common.sh would
# only pick up resources/, so just flatten everything into DEST_DIR.
post_extract() {
    local extract_dir="$1" dest_dir="$2"
    rm -rf "$dest_dir"
    mkdir -p "$dest_dir"
    mv "${extract_dir}"/* "$dest_dir"/
}
