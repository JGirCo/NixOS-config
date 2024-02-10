{

  description = "Configuration flake"

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos/nixos-23.11";
    }
  };

  outputs = {self, nixpkgs, ...}:
  let
    lib = nixpkgs.lib;
  in 
  {
    nixosConfigurations = {
      nixos-config = lib.nixosSystem {
        system = "x86_64-linux";
        modules =  [./configuration.nix];
      }
    };
  };

}
