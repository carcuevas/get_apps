#!/bin/bash

#### This script will get the specified version of ionos cloud CLI
###


VERSION=$1
#VERSION="5.07"



### First we check if we have the version
if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi




PKG=ionosctl
EXEC_FILE=ionosctl
SRC_URL="https://github.com/ionos-cloud/ionosctl/releases/download/v${VERSION}/ionosctl-${VERSION}-linux-amd64.tar.gz"

DEST_DIR="/opt/${PKG}_${VERSION}"
LINK=/bin/${PKG}

## we create the directory
mkdir -p $DEST_DIR 2>/dev/null

## Download the package
wget -O ${DEST_DIR}/${PKG}.tgz "$SRC_URL"
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to download" ; exit 2 ; fi


### To uncompress
cd /opt
tar xzf ${DEST_DIR}/${PKG}.tgz
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} $EXEC_FILE; echo "Failed to untar ${DEST_DIR}/${PKG}.tgz " ; exit 3 ; fi

# So now we can rename our directory to the DEST_DIR
mv /opt/${EXEC_FILE} $DEST_DIR
if [ "$?" -ne 0 ] ; then  rm -rf /opt/${PKG}.tgz /opt/${EXEC_FILE}  ; echo "Failed to move, perhaps installing the same version $DEST_DIR ? ..." ; exit 3 ; fi



rm ${DEST_DIR}/${PKG}.tgz
rm /opt/${PKG}_default

ln -s ${DEST_DIR} /opt/${PKG}_default
ln -s /opt/${PKG}_default/${EXEC_FILE} /bin/${EXEC_FILE} 2>/dev/null
