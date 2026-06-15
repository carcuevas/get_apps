PKG=packer
EXEC_FILE=packer
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=false
NEEDS_CHROME_SANDBOX=false

get_latest() { hashicorp_latest packer; }

url_linux_amd64() { echo "https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_linux_amd64.zip"; }
url_linux_arm64() { echo "https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_linux_arm64.zip"; }
url_macos_amd64() { echo "https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_darwin_amd64.zip"; }
url_macos_arm64() { echo "https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_darwin_arm64.zip"; }
