{ config, lib, pkgs, ... }:

{
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    nix-search-cli

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
    jq
    neovim
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
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    # LC_ALL = "en_US.UTF-8";
    # EDITOR = "nvim";
    # PAGER = "less";
  };

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
