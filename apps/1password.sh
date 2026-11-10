PKG=1password
EXEC_FILE=1password
ARCHIVE_FORMAT=tar.gz
VERSIONED=false      # URL always fetches latest; no version pinning supported
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=true

# No get_latest — URL is always the latest build
url_linux_amd64() { echo "https://downloads.1password.com/linux/tar/beta/x86_64/1password-latest.tar.gz"; }
url_linux_arm64() { echo "https://downloads.1password.com/linux/tar/beta/aarch64/1password-latest.tar.gz"; }
# macOS: pkg/zip installer — TODO
