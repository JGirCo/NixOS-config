{
  description = "Home Manager configuration of juanma";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    old-norg.url =
      "github:nixos/nixpkgs/a343533bccc62400e8a9560423486a3b6c11a23b";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { old-norg, nixpkgs, home-manager, nixvim, ... }@inputs:
    let
      # System settings
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};
      norgpkg = old-norg.legacyPackages.${system};

      # USER settings
      theme = "dracula";
      font = "FantasqueSansM";
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          specialArgs = { };
        };
      };
      homeConfigurations."juanma" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix nixvim.homeManagerModules.nixvim ];
        extraSpecialArgs = {
          inherit inputs;
          inherit theme;
          inherit font;
          inherit norgpkg;
        };
      };
    };
}
