# based on https://github.com/mitchellh/nixos-config/blob/992fd3bc0984cd306e307fd59b22a37af77fca25/Makefile

UNAME := $(shell uname)
SERIAL_NUMBER := $(shell /usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d= -f2 | cut -d\" -f2)

switch:
ifeq ($(UNAME), Darwin)
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes ".#darwinConfigurations.apple-silicon-$(SERIAL_NUMBER).system"
	./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#apple-silicon-$(SERIAL_NUMBER)"
else
	echo "Unimplemented ${UNAME}" >&2
endif
