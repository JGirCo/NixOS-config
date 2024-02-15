{
  description = "Home Manager configuration of juanma";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules =  [./configuration.nix];
          specialArgs = {
          };
        };
      };
      homeConfigurations."juanma" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
        ./home.nix
        nixvim.homeManagerModules.nixvim
        ];
        extraSpecialArgs = {
        };
      };
    };
}
