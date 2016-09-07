#!/bin/bash

set -e

echo " "
echo " *** UPDATING RSYSLOG CONFIG FILES: /etc/rsyslog.d/*.conf"

if [ -z "${NODE_ENV}" ]; then
  echo " ERROR: environment variable NODE_ENV must be set to start this application. Aborting."
  exit 1
fi

# Replace _NODE_ENV_ tokens in config files
sed -i "s/_NODE_ENV_/${NODE_ENV}/" /etc/rsyslog.d/*.conf

echo " "
echo " *** UPDATE COMPLETE: /etc/rsyslog.d/*.conf"
echo " "
