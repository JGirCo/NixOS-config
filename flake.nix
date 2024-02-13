{
  description = "Home Manager configuration of juanma";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."juanma" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules =  [./configuration.nix];
        };
      };
    };
}
