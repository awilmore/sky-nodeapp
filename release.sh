#!/bin/bash

set -e

# Source properties
if [ ! -f "application.conf" ]; then
  echo "error: file not found: application.conf"
  echo "Aborting."
  exit 1
fi

. application.conf

# Fix snapshot
sed -i "s/-snapshot//" artefacts/root/build-info/$VERSION_FILENAME

# Check tag 

# Build image

# Tag repo

# Next snapshot
