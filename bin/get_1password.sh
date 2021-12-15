#!/bin/bash

#### This script will get the last  version of 1password
PKG=1password
SRC_URL="https://downloads.1password.com/linux/tar/beta/x86_64/1password-latest.tar.gz"

DEST_DIR="/opt/${PKG}"
DEST_FILE=1password-latest.tar.gz
LINK=/bin/1password
LIB_DIR=/usr/local/scripts/lib

### We get the file
echo "We get the file..."
mkdir -p $DEST_DIR 2>/dev/null
cd /tmp
curl -sSO ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm  /tmp/${DEST_FILE} ; echo "Failed to download $PKG ..." ; exit 1 ; fi

### We uncompress the file
echo "Uncompressing $PKG ..."
cd /tmp
tar -xzf /tmp/${DEST_FILE}
if [ "$?" -ne 0 ] ; then  rm -rf /tmp/${DEST_FILE} /tmp/1password-*.x64 Postman ; echo -e "\n\n\nFailed to uncompress the $PKG.zip ..." ; exit 3 ; fi

#Get new dir
NEW_DIR=`ls -d 1password-*.x64`
rm -rf ${DEST_DIR}
mv /tmp/${NEW_DIR} ${DEST_DIR}
rm -rf /tmp/${DEST_DIR}

chmod +x ${DEST_DIR}/${PKG}

echo "We do the link to /bin/${PKG}.."
ln -fs ${DEST_DIR}/${PKG} /bin/${PKG}

echo "We install the icon in desktop ... "
cp ${LIB_DIR}/icons/${PKG}.png ${DEST_DIR}/icon.png
sed -e "s/_APP_/$PKG/g" < ${LIB_DIR}/_APP_.desktop > /usr/share/applications/${PKG}.desktop

