#!/bin/bash

#### This script will get the specified version of terraform
###


VERSION=$1
#VERSION="0.13"



### First we check if we have the version
if [ -z "${VERSION}" ] ; then echo "No version specified...exiting ..." ; exit 1 ; fi




PKG=terraform
EXEC_FILE=terraform
SRC_URL="https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"

DEST_DIR="/opt/${PKG}_${VERSION}"
LINK=/bin/${PKG}

## we create the directory
mkdir -p $DEST_DIR 2>/dev/null

## Download the package
wget -O ${DEST_DIR}/${PKG}.zip https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip 
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to download" ; exit 2 ; fi

unzip ${DEST_DIR}/${PKG}.zip -d ${DEST_DIR}/
if [ "$?" -ne 0 ] ; then  rm -rf ${DEST_DIR} ; echo "Failed to unzip ${DEST_DIR}/${PKG}.zip " ; exit 3 ; fi

rm ${DEST_DIR}/${PKG}.zip
rm /opt/${PKG} 

ln -s ${DEST_DIR} /opt/${PKG}
ln -s /opt/${PKG}/${EXEC_FILE} /bin/${EXEC_FILE} 2>/dev/null
