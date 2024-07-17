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
  {
    darwinConfigurations.apple-silicon-D2KC9VXCTJ = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
      ];
      specialArgs = {
        username = "takuya.kosugiyama";
      };
    };

    darwinConfigurations.apple-silicon-JKQVTXD3C6 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
      ];
      specialArgs = {
        username = "takuya.kosugiyama";
      };
    };

    darwinConfigurations.apple-silicon-FVFF3056Q6LW = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
      ];
      specialArgs = {
        username = "itkq";
      };
    };

    homeConfigurations."Darwin-takuya.kosugiyama" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
      };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        {
          home.username = "takuya.kosugiyama";
          home.homeDirectory = "/Users/takuya.kosugiyama";
        }
        ./home.nix
      ];
      extraSpecialArgs = {
        isDarwin = true;
      };
    };

    homeConfigurations.Darwin-itkq = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
      };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        {
          home.username = "itkq";
          home.homeDirectory = "/Users/itkq";
        }
        ./home.nix
      ];
      extraSpecialArgs = {
        isDarwin = true;
      };
    };

    homeConfigurations.Linux-itkq = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        {
          home.username = "itkq";
          home.homeDirectory = "/home/itkq";
        }
        ./home.nix
      ];
      extraSpecialArgs = {
        isDarwin = false;
      };
    };

  };
}
