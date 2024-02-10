{
  description = "Configuration flake";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-23.11";
    };
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager,...}:
  let
    system = "x86_64-linux" ;
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in 
  {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules =  [./configuration.nix];
      };
    };
    homeConfigurations = {
      juanma = home-manager.lib.home-managerConfiguration {
        inherit pkgs;
        inherit system;
        modules =  [./home.nix];
      };
    };
  };
}
