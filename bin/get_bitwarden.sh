#!/bin/bash

#### This script will get the last version of bitwarden
PKG=bitwarden
SRC_URL="https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=appimage"

DEST_DIR="/opt/${PKG}"
DEST_FILE=bitwarden
LINK=/bin/bitwarden
LIB_DIR=/usr/local/scripts/lib

### We get the file
echo "We get the file..."
mkdir -p $DEST_DIR 2>/dev/null
wget -O ${DEST_DIR}/new_${DEST_FILE}  ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm  ${DEST_DIR}/new_${DEST_FILE} ; echo "Failed to download $PKG ..." ; exit 1 ; fi

## We are here so at least we do have downloaded properly the file
mv ${DEST_DIR}/new_${DEST_FILE} ${DEST_DIR}/${DEST_FILE}
chmod +x ${DEST_DIR}/${DEST_FILE}

echo "We do the link to /bin/${PKG}.."
ln -s ${DEST_DIR}/${DEST_FILE} /bin/${PKG} 2>/dev/null

echo "We install the icon in desktop ... "
cp ${LIB_DIR}/icons/${PKG}.png ${DEST_DIR}/icon.png
sed -e "s/_APP_/$PKG/g" < ${LIB_DIR}/_APP_.desktop > /usr/share/applications/${PKG}.desktop

echo "Setting the permissions"
chown root: ${DEST_DIR}/chrome-sandbox
chmod 4755 ${DEST_DIR}/chrome-sandbox

