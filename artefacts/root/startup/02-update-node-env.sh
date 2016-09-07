#!/bin/bash

set -e

echo " "
echo " *** UPDATING NODE ENVIRONMENT CONFIG FILES: /root/.env and /home/nodeapp/.env"

if [ -z "${NODE_ENV}" ]; then
  echo " ERROR: environment variable NODE_ENV must be set to start this application. Aborting."
  exit 1
fi

if [ -z "${PORT}" ]; then
  echo " ERROR: environment variable PORT must be set to start this application. Aborting."
  exit 1
fi

# Create config for root
echo "NODE_ENV=$NODE_ENV" >  /root/.env
echo "PORT=$PORT"         >> /root/.env

# Create config for nodeapp
cp /root/.env /home/nodeapp/.env
chown nodeapp:nodeapp /home/nodeapp/.env

# Fix supervisor conf
sed -i "s/_NODE_ENV_/${NODE_ENV}/" /etc/supervisor/conf.d/*.conf
sed -i "s/_PORT_/${PORT}/" /etc/supervisor/conf.d/*.conf

echo " *** UPDATE COMPLETE: /root/.env and /home/nodeapp/.env"
echo " "
