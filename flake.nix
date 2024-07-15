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

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
    };
    username = "takuya.kosugiyama";
  in
  {
    darwinConfigurations.apple-silicon-D2KC9VXCTJ = darwin.lib.darwinSystem {
      system = system;
      modules = [
        ./darwin.nix
      ];
      specialArgs = {
        username = username;
      };
    };

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        {
          home.username = username;
          home.homeDirectory = "/Users/${username}";
        }
        ./home.nix
      ];
    };
  };
}
