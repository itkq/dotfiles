UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
SERIAL_NUMBER := $(shell /usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d= -f2 | cut -d\" -f2)
endif
NIX_CMD := nix --extra-experimental-features nix-command --extra-experimental-features flakes
FLAKE_HASH := .hash_flake
DARWIN_HASH := .hash_darwin
PRIVATE_HASH := .hash_private

.PHONY: all
all: $(UNAME)

Darwin: darwin home dotfiles
Linux: home dotfiles

result/sw/bin/darwin-rebuild: flake.nix flake.lock
	@if [ ! -f $(FLAKE_HASH) ] || [ ! -f ./result/sw/bin/darwin-rebuild ] || [ "$$($(NIX_CMD) hash file flake.nix)" != "$$(cat $(FLAKE_HASH))" ]; then \
		if ! $(NIX_CMD) build ".#darwinConfigurations.$(SERIAL_NUMBER).system"; then \
			rm -f $(FLAKE_HASH); \
			exit 1; \
		fi; \
		$(NIX_CMD) hash file flake.nix > $(FLAKE_HASH); \
	else \
		echo "flake.nix unchanged, skipping nix build for darwin-rebuild"; \
	fi

.PHONY: darwin
darwin: result/sw/bin/darwin-rebuild
	@if [ ! -f $(DARWIN_HASH) ] || [ "$$($(NIX_CMD) hash file darwin.nix)" != "$$(cat $(DARWIN_HASH))" ] \
		|| [ ! -f $(PRIVATE_HASH) ] || [ "$$(which jq >/dev/null && jq -r '.nodes.private.locked.rev' < flake.lock || echo 'unknown')" != "$$(cat $(PRIVATE_HASH))" ]; then \
		if ! ./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#$(SERIAL_NUMBER)"; then \
			rm -f $(DARWIN_HASH); \
			exit 1; \
		fi; \
		$(NIX_CMD) hash file darwin.nix > $(DARWIN_HASH); \
		(which jq >/dev/null && jq -r '.nodes.private.locked.rev' < flake.lock || echo 'unknown') > $(PRIVATE_HASH); \
  else \
		echo "darwin.nix and private config unchanged, skipping darwin-rebuild"; \
	fi

result/activate: flake.nix flake.lock
	@$(NIX_CMD) build .\#homeConfigurations.\"$(UNAME)-$(USER)\".activationPackage

.PHONY: home
home: result/activate
	@./result/activate

.PHONY: update
update:
	@$(NIX_CMD) flake update

.PHONY: upgrade
upgrade: update all

.PHONY: clean
clean:
	rm -f $(FLAKE_HASH) $(DARWIN_HASH) $(PRIVATE_HASH)

.PHONY: dotfiles
dotfiles:
	@./scripts/deploy-config.sh

.PHONY: bootstrap
# FIXME: validate checksum
bootstrap:
	# https://github.com/DeterminateSystems/nix-installer
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

ifeq ($(UNAME), Darwin)
	# https://brew.sh/
	@NONINTERACTIVE=1 sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
endif
