#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $0)/..
mkdir -p ~/.config
pwd="$(pwd)"

for p in $(find ${pwd}/config -type d -depth 2); do
	dir=$(basename "$p")
	set -x
	./scripts/symlink.sh "${pwd}/config/.config/${dir}" "$HOME/.config/${dir}"
	{ set +x; } 2>/dev/null
done

for p in $(find ${pwd}/config -type f -depth 1); do
	file=$(basename "$p")
	set -x
	./scripts/symlink.sh "${pwd}/config/${file}" "$HOME/${file}"
	{ set +x; } 2>/dev/null
done
