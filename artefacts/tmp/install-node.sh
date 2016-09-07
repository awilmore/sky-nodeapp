#!/bin/bash

set -e

echo " "
echo " ************************************************************ "
echo " ***                                                      *** "
echo " ***                INSTALLING NODE 6                     *** "
echo " ***                                                      *** "
echo " ************************************************************ "
echo " "

echo " * Adding new nodeapp user..."
adduser --disabled-password --gecos "" nodeapp

echo " * Updating sudoers..."
echo "nodeapp  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo " * Removing old node_modules..."
rm -rf /usr/lib/node_modules

echo " * Downloading setup_6.sh script..."
curl -sL https://deb.nodesource.com/setup_6.x > /tmp/setup_6.sh

echo " * Running setup_6.sh script..."
bash /tmp/setup_6.sh

echo " * Running apt-get install nodejs..."
apt-get install nodejs -y

echo " * Preparing log folder..."
mkdir -p /var/log/nodeapp
chown -R nodeapp:nodeapp /var/log/nodeapp

echo " "
echo " ************************************************************ "
echo " ***                                                      *** "
echo " ***            NODE 5 INSTALLATION COMPLETE              *** "
echo " ***                                                      *** "
echo " ************************************************************ "
echo " "
