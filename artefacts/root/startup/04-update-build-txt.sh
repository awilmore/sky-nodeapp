#!/bin/bash

BUILD_TXT=`find /usr/src/app -name build.txt -print | head -1`

if [ ! -f "$BUILD_TXT" ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo " ~~~                                                        ~~~ "
  echo " ~~~ WARNING: no build.txt found in project folder:         ~~~ "
  echo " ~~~          /usr/src/app                                  ~~~ "
  echo " ~~~          No build.txt updated for this project.        ~~~ "
  echo " ~~~                                                        ~~~ "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit
fi

# Update build.txt with running environment
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo " ~~~                UPDATING BUILD.TXT FILE                 ~~~ "

# Check environment variable
if [ -z "${NODE_ENV}" ]; then
  echo " ERROR: "
  echo " environment variable NODE_ENV must be set to run this script. Aborting."
  exit 1
fi

# Get nodeapp base version
NODEAPP_VERSION=`cat /root/build-info/nodeapp-version.txt`

# Gather rancher details, if present
DOCKER_HOST=`curl -s http://rancher-metadata/latest/self/host/name`
CONTAINER_NAME=`curl -s http://rancher-metadata/latest/self/container/labels/io.rancher.stack_service.name`
CONTAINER_ID=`hostname`

# Display details
echo " ~~~ DETAILS:                                               ~~~ "
echo " ~~~   - NODEAPP VERSION : ${NODEAPP_VERSION}"
echo " ~~~   - NODE_ENV        : ${NODE_ENV}"
echo " ~~~   - DOCKER HOST     : ${DOCKER_HOST}"
echo " ~~~   - CONTAINER NAME  : ${CONTAINER_NAME}"
echo " ~~~   - CONTAINER ID    : ${CONTAINER_ID}"
echo " ~~~                                                        ~~~ "

# Check existing config
set +e
if grep 'environment:' $BUILD_TXT > /dev/null
then
  echo " ~~~ WARNING: environment value already present.            ~~~ "
  echo " ~~~          Skipping build.txt update.                    ~~~ "
  echo " ~~~                                                        ~~~ "

else
  # Write value to file
  echo "nodeapp_version: ${NODEAPP_VERSION}" >> $BUILD_TXT
  echo "environment: ${NODE_ENV}"            >> $BUILD_TXT
  echo "docker_host: ${DOCKER_HOST}"         >> $BUILD_TXT
  echo "container_name: ${CONTAINER_NAME}"   >> $BUILD_TXT
  echo "container_id: ${CONTAINER_ID}"       >> $BUILD_TXT

  echo " ~~~ FILE UPDATED SUCCESSFULLY.                             ~~~ "
  echo " ~~~                                                        ~~~ "
fi
set -e

# Display result
echo " ~~~ DISPLAYING FILE CONTENTS (build.txt):                  ~~~ "
echo " ~~~                                                        ~~~ "

cat $BUILD_TXT

echo " ~~~                                                        ~~~ "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo " "
