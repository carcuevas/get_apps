#!/bin/bash


#### This script will get the specified version of Visual Studio Code
###
### Due to the fact that Visual Code is using two destkop files
### we are copying them directly


VERSION=$1

#VERSION=1.48.2


### To be installed
#gtk3
#libxkbfile
#gnupg 
#libsecret 
#gcc-libs 
#libnotify
#glibc 
#lsof
#nss
#libxss


### First we check if we have the version
#if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi



echo -e "it is needed to execute for first time...\n\n"
echo "pacman -S gtk3 nss libxkbfile gnupg libsecret gcc-libs libnotify glibc lsof nss libxss"


#### This script will get the specified version of Code
PKG=code
EXEC_FILE=code
#SRC_URL="https://update.code.visualstudio.com/${VERSION}/linux-x64/stable"
SRC_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"

#DEST_DIR="/opt/${PKG}_${VERSION}"
DEST_DIR="/opt/${PKG}"
LINK=/bin/${PKG}
LIB_DIR=/usr/local/scripts/lib


### We get the file
echo "We get the file..."
wget -O /opt/${PKG}.tar.gz  ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm -r /opt/${PKG}.tar.gz ; echo "Failed to download $PKG ..." ; exit 2 ; fi

## We are here so at least we do have downloaded properly the file
echo "Uncompressing $PKG ..."

## For Visual Code when uncompressing creates the directory  VSCode-linux-x64 where all the files will be saved
cd /opt
tar -xzf ${PKG}.tar.gz
if [ "$?" -ne 0 ] ; then  rm -rf /opt/${PKG}.tar.gz VSCode-linux-x64 ; echo -e "\n\n\nFailed to unzip the $PKG.zip ..." ; exit 3 ; fi

# So now we can rename our directory to the DEST_DIR
mv /opt/VSCode-linux-x64 $DEST_DIR
if [ "$?" -ne 0 ] ; then  rm -rf /opt/${PKG}.tar.gz VSCode-linux-x64 ; echo "Failed to moved, perhaps installing the same version $DEST_DIR ? ..." ; exit 3 ; fi


## Remove the old link if existed
echo "Removing old links if existed ..."
rm /opt/${PKG} 2>/dev/null

## So if we are here we can do the links
echo "Creating the new links... "
ln -s ${DEST_DIR} /opt/${PKG} 
ln -s /opt/${PKG}/${EXEC_FILE} /bin/${EXEC_FILE} 2>/dev/null


echo "We install the icon in desktop ... "
cp ${LIB_DIR}/icons/${PKG}.png ${DEST_DIR}/icon.png
cp ${LIB_DIR}/visual-studio-cod*desktop /usr/share/applications/

echo "All good removing the compressed file"
rm -r /opt/${PKG}.tar.gz 

echo "Also we set some permissions"
chown root: /opt/code/chrome-sandbox
chmod 4755 /opt/code/chrome-sandbox

