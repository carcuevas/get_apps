PKG=logcli
EXEC_FILE=logcli
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=false
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest grafana loki; }

url_linux_amd64() { echo "https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-linux-amd64.zip"; }
url_linux_arm64() { echo "https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-linux-arm64.zip"; }
url_macos_amd64() { echo "https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-darwin-amd64.zip"; }
url_macos_arm64() { echo "https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-darwin-arm64.zip"; }

post_extract() {
    local src="$1" dest="$2"
    # zip contains logcli-{os}-{arch} binary — rename to just logcli
    local os_label="$OS"
    [ "$os_label" = "macos" ] && os_label="darwin"
    mv "${src}/logcli-${os_label}-${ARCH}" "${dest}/${EXEC_FILE}"
    chmod 755 "${dest}/${EXEC_FILE}"
}
