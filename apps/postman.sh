PKG=postman
EXEC_FILE=Postman
ARCHIVE_FORMAT=tar.gz
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

# No reliable public API for latest version — use: getapp postman -v VERSION
# Example: getapp postman -v 11.4.2

url_linux_amd64() { echo "https://dl.pstmn.io/download/version/${VERSION}/linux64"; }
# macOS: available at dl.pstmn.io — TODO
# ARM64: not yet reliably available for Postman

post_extract() {
    local src="$1" dest="$2"
    # tar.gz extracts to a single "Postman" directory
    local subdir
    subdir=$(find "$src" -maxdepth 1 -mindepth 1 -type d | head -1)
    [ -z "$subdir" ] && die "Could not find extracted Postman directory"
    rm -rf "$dest"
    mv "$subdir" "$dest"
}
