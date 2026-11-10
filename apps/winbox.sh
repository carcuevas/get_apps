PKG=winbox
EXEC_FILE=WinBox
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=true
NEEDS_CHROME_SANDBOX=false

# No API for latest WinBox version — use -v VERSION  e.g.: getapp winbox -v 4.1
# macOS build is a universal binary (Intel + Apple Silicon) distributed as a single DMG

url_linux_amd64() { echo "https://download.mikrotik.com/routeros/winbox/${VERSION}/WinBox_Linux.zip"; }
url_macos_amd64() { echo "https://download.mikrotik.com/routeros/winbox/${VERSION}/WinBox.dmg"; }
url_macos_arm64() { echo "https://download.mikrotik.com/routeros/winbox/${VERSION}/WinBox.dmg"; }
