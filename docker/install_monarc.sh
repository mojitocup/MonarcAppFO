#!/bin/bash
PATH_TO_MONARC='/var/lib/monarc/fo'
PATH_TO_MONARC_DATA='/var/lib/monarc/fo-data'
MONARC_VERSION=$(curl --silent -H 'Content-Type: application/json' https://api.github.com/repos/monarc-project/MonarcAppFO/releases/latest | jq  -r '.tag_name')
MONARCFO_RELEASE_URL="https://github.com/monarc-project/MonarcAppFO/releases/download/$MONARC_VERSION/MonarcAppFO-$MONARC_VERSION.tar.gz"

mkdir -p /var/lib/monarc/releases/
# Download release
curl -sL $MONARCFO_RELEASE_URL -o /var/lib/monarc/releases/`basename $MONARCFO_RELEASE_URL`
# Create release directory
mkdir /var/lib/monarc/releases/`basename $MONARCFO_RELEASE_URL | sed 's/.tar.gz//'`
# Unarchive release
tar -xzf /var/lib/monarc/releases/`basename $MONARCFO_RELEASE_URL` -C /var/lib/monarc/releases/`basename $MONARCFO_RELEASE_URL | sed 's/.tar.gz//'`
# Create release symlink
ln -s /var/lib/monarc/releases/`basename $MONARCFO_RELEASE_URL | sed 's/.tar.gz//'` $PATH_TO_MONARC
# Create data and caches directories
mkdir -p $PATH_TO_MONARC_DATA/cache $PATH_TO_MONARC_DATA/DoctrineORMModule/Proxy $PATH_TO_MONARC_DATA/LazyServices/Proxy $PATH_TO_MONARC_DATA/import/files
# Create data directory symlink
ln -s $PATH_TO_MONARC_DATA $PATH_TO_MONARC/data