{ config, lib, pkgs, nixpkgsUnstable, isDarwin, ... }:

{
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    awscli2
    azure-cli
    bat
    cargo
    cue
    cuetools
    coreutils
    delve
    deno
    difftastic
    direnv
    envsubst
    findutils
    fnm
    fzf
    gawk
    gh
    ghq
    gnugrep
    gnupg
    gnused
    go
    google-cloud-sdk
    golangci-lint
    gopls
    htop
    jrsonnet
    jq
    nixpkgsUnstable.neovim
    nix-search-cli
    nodejs
    nodePackages.npm
    peco
    postgresql_16
    ripgrep
    ruby_3_3
    ssm-session-manager-plugin
    tig
    wezterm
    zsh
    (callPackage ./pkgs/aqua.nix { })
  ] ++ (lib.optionals isDarwin [
    alt-tab-macos
    discord
    pinentry_mac
    (callPackage ./pkgs/whichpr.nix { }) # some problem in WSL2
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
