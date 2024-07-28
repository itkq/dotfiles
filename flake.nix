{
  description = "Nix config by itkq";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private = {
      url = "git+ssh://git@github.com/itkq/dotfiles-private";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, private, ... }@inputs:
  let
    commonDarwinConfig = { username, extraModules ? [] }: darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin.nix ] ++ extraModules;
      specialArgs = { inherit username; };
    };

    commonHomeConfig = { username, homeDir, system, isDarwin }: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        {
          home.username = username;
          home.homeDirectory = homeDir;
        }
        ./home.nix
      ];
      extraSpecialArgs = { 
        inherit isDarwin;
        nixpkgsUnstable = import nixpkgs-unstable { inherit system; };
      };
    };
  in {
    darwinConfigurations.D2KC9VXCTJ = commonDarwinConfig { 
      username = "takuya.kosugiyama";
      extraModules = [ "${private}/darwin-layerx.nix" ];
    };
    darwinConfigurations.JKQVTXD3C6 = commonDarwinConfig { username = "takuya.kosugiyama"; };
    darwinConfigurations.FVFF3056Q6LW = commonDarwinConfig { username = "itkq"; };

    homeConfigurations."Darwin-takuya.kosugiyama" = commonHomeConfig {
      username = "takuya.kosugiyama";
      homeDir = "/Users/takuya.kosugiyama";
      system = "aarch64-darwin";
      isDarwin = true;
    };
    homeConfigurations.Darwin-itkq = commonHomeConfig {
      username = "itkq";
      homeDir = "/Users/itkq";
      system = "aarch64-darwin";
      isDarwin = true;
    };
    homeConfigurations.Linux-itkq = commonHomeConfig {
      username = "itkq";
      homeDir = "/home/itkq";
      system = "x86_64-linux";
      isDarwin = false;
    };
  };
}
