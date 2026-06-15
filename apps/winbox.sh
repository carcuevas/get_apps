PKG=winbox
EXEC_FILE=WinBox
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

# No reliable API for latest WinBox version — use -v VERSION
# Example: getapp winbox -v 4.0beta17

url_linux_amd64() { echo "https://download.mikrotik.com/routeros/winbox/${VERSION}/WinBox_Linux.zip"; }
# macOS: WinBox_MacOS.zip available from Mikrotik — TODO
