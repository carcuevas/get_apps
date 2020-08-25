#!/bin/bash


#### This script will get the specified version of Postman
###
### Due to the fact that Visual Code is using two destkop files
### we are copying them directly


VERSION=$1

#VERSION=7.31.0


### To be installed
#electron7


### First we check if we have the version
if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi



echo -e "it is needed to execute for first time...\n\n"
echo "pacman -S electron7"


#### This script will get the specified version of Code
PKG=postman
EXEC_FILE=Postman
SRC_URL="https://dl.pstmn.io/download/version/${VERSION}/linux64"

DEST_DIR="/opt/${PKG}_${VERSION}"
LINK=/bin/${PKG}
LIB_DIR=/usr/local/scripts/lib


### We get the file
echo "We get the file..."
wget -O /opt/${PKG}.tar.gz  ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm -r /opt/${PKG}.tar.gz ; echo "Failed to download $PKG ..." ; exit 2 ; fi

## We are here so at least we do have downloaded properly the file
echo "Uncompressing $PKG ..."

## For Postman when uncompressing creates the directory Postman where all the files will be saved
cd /opt
tar -xzf ${PKG}.tar.gz
if [ "$?" -ne 0 ] ; then  rm -rf /opt/${PKG}.tar.gz Postman ; echo -e "\n\n\nFailed to uncompress the $PKG.zip ..." ; exit 3 ; fi

# So now we can rename our directory to the DEST_DIR
mv /opt/Postman $DEST_DIR
if [ "$?" -ne 0 ] ; then  rm -rf /opt/${PKG}.tar.gz Postman ; echo "Failed to move, perhaps installing the same version $DEST_DIR ? ..." ; exit 3 ; fi


## Remove the old link if existed
echo "Removing old links if existed ..."
rm /opt/${PKG} 2>/dev/null

## So if we are here we can do the links
echo "Creating the new links... "
ln -s ${DEST_DIR} /opt/${PKG} 
ln -s /opt/${PKG}/${EXEC_FILE} /bin/$PKG 2>/dev/null


echo "We install the icon in desktop ... "
cp ${LIB_DIR}/icons/${PKG}.png ${DEST_DIR}/icon.png
sed -e "s/_APP_/$PKG/g" < ${LIB_DIR}/_APP_.desktop > /usr/share/applications/${PKG}.desktop

echo "All good removing the compressed file"
rm -r /opt/${PKG}.tar.gz 
