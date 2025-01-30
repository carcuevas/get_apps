#!/bin/bash


#### This script will get the specified version of Linux WinBox
###
### Due to the complexity of the .desktop file we are not
### using the template but the one edited winbox.desktop


VERSION=$1

#VERSION=4.0beta17


### To be installed


### First we check if we have the version
if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi


## For ARch Linux if needed extra packages
#echo -e "it is needed to execute for first time...\n\n"
#echo "pacman -S gtk3 nss alsa-lib libxss ttf-font unzip"


#### This script will get the specified version of Brave
PKG=winbox
EXEC_FILE=WinBox
SRC_URL="https://download.mikrotik.com/routeros/winbox/${VERSION}/WinBox_Linux.zip"

DEST_DIR="/opt/${PKG}_${VERSION}"
LINK=/bin/${PKG}
LIB_DIR=/usr/local/scripts/lib
### We get the file
echo "We get the file..."
mkdir -p $DEST_DIR 2>/dev/null
wget -O ${DEST_DIR}/${PKG}.zip  ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to download $PKG ..." ; exit 2 ; fi

## We are here so at least we do have downloaded properly the file
echo "Uncompressing $PKG ..."
unzip ${DEST_DIR}/${PKG}.zip -d ${DEST_DIR}
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo -e "\n\n\nFailed to unzip the $PKG.zip ..." ; exit 3 ; fi


## Remove the old link if existed
echo "Removing old links if existed ..."
rm /opt/${PKG} 2>/dev/null

## So if we are here we can do the links
echo "Creating the new links... "
ln -s ${DEST_DIR} /opt/${PKG} 
ln -s /opt/${PKG}/${EXEC_FILE} /usr/local/bin/${EXEC_FILE} 2>/dev/null

chmod +x ${DEST_DIR}/${DEST_FILE}

echo "We install the icon in desktop ... "
cp ${LIB_DIR}/icons/${PKG}.png ${DEST_DIR}/icon.png
cp ${LIB_DIR}/winbox.desktop /usr/share/applications/

