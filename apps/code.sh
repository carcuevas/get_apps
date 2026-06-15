PKG=code
EXEC_FILE=code
ARCHIVE_FORMAT=tar.gz
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true

get_latest() { gh_latest microsoft vscode; }

url_linux_amd64() { echo "https://update.code.visualstudio.com/${VERSION}/linux-x64/stable"; }
url_linux_arm64() { echo "https://update.code.visualstudio.com/${VERSION}/linux-arm64/stable"; }
url_macos_amd64() { echo "https://update.code.visualstudio.com/${VERSION}/darwin/stable"; }
url_macos_arm64() { echo "https://update.code.visualstudio.com/${VERSION}/darwin-arm64/stable"; }

post_extract() {
    local src="$1" dest="$2"
    # tar.gz extracts to a single dir (e.g. VSCode-linux-x64) — rename it
    local subdir
    subdir=$(find "$src" -maxdepth 1 -mindepth 1 -type d | head -1)
    [ -z "$subdir" ] && die "Could not find extracted VS Code directory"
    rm -rf "$dest"
    mv "$subdir" "$dest"
}

post_install() {
    # VS Code ships a second desktop file for URL handling
    [ "$OS" = "linux" ] && cp "${LIB_DIR}/visual-studio-code-url-handler.desktop" "${DESKTOP_DIR}/" 2>/dev/null || true
}
