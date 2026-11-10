PKG=terraform
EXEC_FILE=terraform
ARCHIVE_FORMAT=zip
NEEDS_DESKTOP=false
NEEDS_CHROME_SANDBOX=false

get_latest() { hashicorp_latest terraform; }

url_linux_amd64() { echo "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"; }
url_linux_arm64() { echo "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_arm64.zip"; }
url_macos_amd64() { echo "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_darwin_amd64.zip"; }
url_macos_arm64() { echo "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_darwin_arm64.zip"; }
