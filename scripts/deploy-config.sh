#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $0)/..
mkdir -p ~/.config
pwd="$(pwd)"

uname=$(uname)
if [[ "$uname" == "Linux" ]]; then
  export PINENTRY_PROGRAM="$HOME/.config/gnupg/pinentry-wsl-ps1.sh"
elif [[ "$uname" == "Darwin" ]]; then
  export PINENTRY_PROGRAM="$HOME/.nix-profile/bin/pinentry-mac"
else
  echo "Unsupported uname: $uname" >&2
  exit 1
fi

for p in $(git ls-files | grep -E '^config/.config' | cut -d/ -f2-); do
  if [[ "$p" == *".template" ]]; then
    dst=$(echo $p | sed -e 's/.template$//')
    envsubst <"config/$p" >"$HOME/$dst"
  else
    mkdir -p "$HOME/$(dirname $p)"
    ./scripts/symlink.sh "${pwd}/config/$p" "$HOME/$p"
  fi
done
