{ config, lib, pkgs, isDarwin, ... }:

{
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    awscli2
    bat
    cue
    cuetools
    delve
    difftastic
    direnv
    findutils
    fzf
    gawk
    gh
    ghq
    gnugrep
    gnupg
    gnused
    go
    golangci-lint
    gopls
    htop
    jq
    neovim
    nix-search-cli
    nodejs
    nodePackages.npm
    peco
    ripgrep
    ruby_3_3
    tig
    wezterm
    zsh
    (callPackage ./pkgs/aqua.nix { })
  ] ++ (lib.optionals isDarwin [
    alt-tab-macos
    discord
    pinentry_mac
  ]);

  programs.zsh = {
    enable = true;
    dotDir = ".config";
    antidote = {
      enable = true;
      package = pkgs.antidote;
      useFriendlyNames = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };
    initExtraFirst = ''
      if [ -f $HOME/.config/zsh/.zshrc.entrypoint ]; then
        source $HOME/.config/zsh/.zshrc.entrypoint
      fi
    '';
  };
}
