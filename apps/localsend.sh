PKG=localsend
EXEC_FILE=localsend.AppImage
ARCHIVE_FORMAT=appimage
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

get_latest() { gh_latest localsend localsend; }

url_linux_amd64() { echo "https://github.com/localsend/localsend/releases/download/v${VERSION}/LocalSend-${VERSION}-linux-x86-64.AppImage"; }
