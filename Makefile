UNAME := $(shell uname)
SERIAL_NUMBER := $(shell /usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d= -f2 | cut -d\" -f2)
NIX_CMD := nix --extra-experimental-features nix-command --extra-experimental-features flakes
FLAKE_HASH := .hash_flake
DARWIN_HASH := .hash_darwin

.PHONY: all
all: darwin-switch home-switch dotfiles

result/sw/bin/darwin-rebuild: flake.nix
	@if [ ! -f $(FLAKE_HASH) ] || [ "$$($(NIX_CMD) hash file flake.nix)" != "$$(cat $(FLAKE_HASH))" ]; then \
		if ! $(NIX_CMD) build ".#darwinConfigurations.apple-silicon-$(SERIAL_NUMBER).system"; then \
			rm -f $(FLAKE_HASH); \
			exit 1; \
		fi; \
		$(NIX_CMD) hash file flake.nix > $(FLAKE_HASH); \
	else \
		echo "flake.nix unchanged, skipping nix build for darwin-rebuild"; \
	fi

.PHONY: darwin-switch
darwin-switch: result/sw/bin/darwin-rebuild
ifeq ($(UNAME), Darwin)
	@if [ ! -f $(DARWIN_HASH) ] || [ "$$($(NIX_CMD) hash file darwin.nix)" != "$$(cat $(DARWIN_HASH))" ]; then \
		if ! ./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#apple-silicon-$(SERIAL_NUMBER)"; then \
			rm -f $(DARWIN_HASH); \
			exit 1; \
		fi; \
		$(NIX_CMD) hash file darwin.nix > $(DARWIN_HASH); \
	else \
		echo "darwin.nix unchanged, skipping darwin-rebuild"; \
	fi
else
	@echo "Unimplemented ${UNAME}" >&2
endif

result/activate: flake.nix
	@$(NIX_CMD) build .\#homeConfigurations.\"$(USER)\".activationPackage

.PHONY: home-switch
home-switch: result/activate
	@./result/activate

.PHONY: update
update:
	@$(NIX_CMD) flake update

.PHONY: upgrade
upgrade: clean update darwin-switch home-switch

.PHONY: clean
clean:
	rm -f $(DARWIN_HASH) $(FLAKE_HASH)

.PHONY: dotfiles
dotfiles:
	@./scripts/deploy-config.sh
