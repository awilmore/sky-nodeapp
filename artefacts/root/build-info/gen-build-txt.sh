#!/bin/bash

set -e

SOURCE_TXT="/root/build-info/version.txt"
BUILD_TXT=`find /usr/src/app -name build.txt -print | head -1`

echo " "

if [ -f "$BUILD_TXT" ]; then
  # Extract version
  VERSION=`cat $SOURCE_TXT`
  NPM_VERSION=`npm --version`
  NODE_VERSION=`node --version`

  # Update build.txt
  echo "version: $VERSION" > $BUILD_TXT
  echo "apptype: docker" >> $BUILD_TXT
  echo "npm_version: $NPM_VERSION" >> $BUILD_TXT
  echo "node_version: $NODE_VERSION" >> $BUILD_TXT

  # Report
  echo "File successfully updated: $BUILD_TXT"
else
  echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
  echo " !!!                                 !!! "
  echo " !!!         !!! WARNING !!!         !!! "
  echo " !!!                                 !!! "
  echo " !!! Node app build.txt file not     !!! "
  echo " !!! found at expected path. Build   !!! "
  echo " !!! details could not be updated!   !!! "
  echo " !!!                                 !!! "
  echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
fi

echo " "
