#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
	echo "Invalid number of arguments"
	exit 1
fi

SOURCE_FOLDER=$1/
DEST_FOLDER=$2
DATE=`date +%d.%m.%Y`
DEST_PATH=$2/$(basename $1).backup.$DATE/

echo target: $DEST_PATH
mkdir -p $DEST_PATH

if [ -d "$SOURCE_FOLDER" ]; then
	echo source: $SOURCE_FOLDER
	rsync --progress -a --delete $SOURCE_FOLDER/ $DEST_PATH/
fi

