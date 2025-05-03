.PHONY: all
all: dotfiles

.PHONY: dotfiles
dotfiles:
	@./scripts/deploy-config.sh
