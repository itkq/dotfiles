{
  description = "Nix config by itkq";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
  let
    commonDarwinConfig = { username }: darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin.nix ];
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
      extraSpecialArgs = { inherit isDarwin; };
    };
  in {
    darwinConfigurations.D2KC9VXCTJ = commonDarwinConfig { username = "takuya.kosugiyama"; };
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
