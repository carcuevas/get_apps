PKG=slack
EXEC_FILE=slack
ARCHIVE_FORMAT=tar.gz
NEEDS_DESKTOP=false
NEEDS_CHROME_SANDBOX=false

get_latest() {
    curl -s "https://docs.slack.dev/tools/metadata.json" \
        | grep -A6 '"slack-cli"' | grep '"version"' | head -1 | cut -d'"' -f4
}

url_linux_amd64() { echo "https://downloads.slack-edge.com/slack-cli/slack_cli_${VERSION}_linux_amd64.tar.gz"; }
url_linux_arm64() { echo "https://downloads.slack-edge.com/slack-cli/slack_cli_${VERSION}_linux_arm64.tar.gz"; }
# macOS: slack_cli_{VERSION}_macOS_{amd64,arm64}.tar.gz — TODO

# Archive ships "bin/slack" + "LICENSE" — the default single-subdir handling
# in common.sh renames "bin/" itself to DEST_DIR, so EXEC_FILE=slack works
# with no post_extract needed (LICENSE is simply dropped).
