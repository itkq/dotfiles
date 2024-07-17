#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $0)/..
mkdir -p ~/.config
pwd="$(pwd)"

for p in $(find ${pwd}/config -mindepth 2 -maxdepth 2 -type d); do
	dir=$(basename "$p")
	./scripts/symlink.sh "${pwd}/config/.config/${dir}" "$HOME/.config/${dir}"
done

for p in $(find ${pwd}/config -mindepth 1 -maxdepth 1 -type f); do
	file=$(basename "$p")
	./scripts/symlink.sh "${pwd}/config/${file}" "$HOME/${file}"
done
