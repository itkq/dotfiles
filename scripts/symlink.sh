#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 source target"
	exit 1
fi

SOURCE=$1
TARGET=$2

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" == "$SOURCE" ]; then
	exit 0
fi

if [ -L "$TARGET" ]; then
	echo "Removing existing symlink: $TARGET"
	rm "$TARGET"
elif [ -e "$TARGET" ]; then
	echo "Removing existing file or directory: $TARGET"
	rm -rf "$TARGET"
fi

echo "Creating new symlink: $TARGET -> $SOURCE"
ln -s "$SOURCE" "$TARGET"
