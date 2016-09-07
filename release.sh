#!/bin/bash

set -e

check_file() {
  FILE=$1
  if [ ! -f "$FILE" ]; then
    echo "error: file not found: $FILE"
    echo "Aborting."
    exit 1
  fi
}

check_tag_exists() {
  TAG=$1
  REF=$( git ls-remote origin "refs/tags/$TAG" )

  if [ ! -z "$REF" ]; then
    echo "error: tag already exists: $TAG"
    echo "Aborting."
    exit 1
  fi
}

increment_version() {
  VER=$1
  [[ "$VER" =~ (.*[^0-9])([0-9]+)$ ]] && VER="${BASH_REMATCH[1]}$((${BASH_REMATCH[2]} + 1))";
  echo $VER
}




# Source properties
check_file "application.conf"
. application.conf

# Fix snapshot
VERSION_FILE="artefacts/root/build-info/${VERSION_FILENAME}"
check_file "$VERSION_FILE"

echo " * Updating version file: $VERSION_FILE ..."
if [ `uname` = "Darwin" ]; then
  sed -i "" "s/-snapshot//" $VERSION_FILE
else
  sed -i "s/-snapshot//" $VERSION_FILE
fi

# Check tag 
VERSION=`cat $VERSION_FILE`
TAG="version-$VERSION"
echo " * Checking tag: $TAG ..."
check_tag_exists $TAG

# Build image
IMAGE=$( docker-compose config | grep 'image:' | awk '{print $2}' )
echo " * Building image: $IMAGE ..."
time docker-compose build

# Tag image
echo " * Tagging image:latest $IMAGE:$VERSION ..."
docker tag $IMAGE:latest $IMAGE:$VERSION

# Push image
echo " * Pusing images ..."
docker push $IMAGE:latest 
docker push $IMAGE:$VERSION

# Tag repo
echo " * Tagging repo ..."
echo " "
git config user.name "Release Manager"
git config user.email "release@edge"
git add $VERSION_FILE
git commit -m "[RELMGMT: Updated version.txt to version $VERSION]"
git push origin

echo " "
git tag -a version-$VERSION -m "[RELMGMT: Tagged version $VERSION]"
git push origin version-$VERSION
echo " "

# Next snapshot
echo " * Setting next snapshot ..."
NEXTV=$( increment_version $VERSION )
echo "$NEXTV-snapshot" > $VERSION_FILE
git add $VERSION_FILE
git commit -m "[RELMGMT: Updated version.txt to version $NEXTV-snapshot]"
git push origin

# Finished
echo " *** RELEASE COMPLETE ***"
echo " "
