{ user, inputs, ... }:

{ config, lib, pkgs, ... }:

{
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    alt-tab-macos # darwin only!
    bat
    direnv
    discord
    fzf
    gawk
    gh
    ghq
    gnugrep
    gnused
    htop
    inputs.nixpkgs-unstable.legacyPackages.${system}.neovim
    inputs.nixpkgs-unstable.legacyPackages.${system}.nerdfonts
    jq
    peco
    ripgrep
    tig
    wezterm
    zsh
    zinit

    # go
    go
    gopls
    delve
    golangci-lint

    # node
    nodejs
    nodePackages.npm

    # ruby
    ruby_3_3

    # cloud
    awscli2
  ];
  home.username = user;
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less";
  };

  xdg = import ./home/lib/xdg.nix {};
}
