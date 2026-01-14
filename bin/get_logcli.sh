#!/bin/bash

#### This script will get the specified version of Grafana Logcli
###


VERSION=$1
#VERSION="0.13"



### First we check if we have the version
if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi




PKG=logcli
EXEC_FILE=logcli
SRC_URL="https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-linux-amd64.zip"

DEST_DIR="/opt/${PKG}_${VERSION}"
LINK=/bin/${PKG}

## we create the directory
mkdir -p $DEST_DIR 2>/dev/null

## Download the package
wget -O ${DEST_DIR}/${PKG}.zip ${SRC_URL}
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to download" ; exit 2 ; fi

unzip ${DEST_DIR}/${PKG}.zip -d ${DEST_DIR}/
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to unzip ${DEST_DIR}/${PKG}.zip " ; exit 3 ; fi

mv ${DEST_DIR}/${PKG}-linux-amd64 ${DEST_DIR}/${PKG}
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Could not rename the application to ${DEST_DIR}/${PKG}" ; exit 4 ; fi

chmod 755 ${DEST_DIR}/${PKG}

rm ${DEST_DIR}/${PKG}.zip
rm /opt/${PKG} 

ln -s ${DEST_DIR} /opt/${PKG}
ln -s /opt/${PKG}/${EXEC_FILE} /usr/local/bin/${EXEC_FILE} 2>/dev/null
