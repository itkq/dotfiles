{ user, inputs, ... }:

{ config, lib, pkgs, ... }:

{
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    alt-tab-macos # darwin only!
    bat
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
    ripgrep
  ];
  home.username = user;
}
