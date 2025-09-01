{
  description = "Home Manager configuration of jgirco";

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
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    legion-kb-rgb.url = "github:4JX/L5P-Keyboard-RGB";
    legion-kb-rgb.inputs.nixpkgs.follows = "nixpkgs";

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { old-norg, nixpkgs, home-manager, nixvim, nix-flatpak, ... }@inputs:
    let
      # System settings
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};
      norgpkg = old-norg.legacyPackages.${system};

      # USER settings
      theme = "rose-pine-dawn";
      font = {
        name = "Maple Mono NF";
        isNF = false;
      };
      browser = { name = "firefox-nightly"; };
      flake-overlays = [ ];
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix flake-overlays)
            nix-flatpak.nixosModules.nix-flatpak
          ];
          specialArgs = {
            inherit browser;
            inherit font;
            inherit inputs;
          };
        };
      };
      homeConfigurations."jgirco" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix nixvim.homeModules.nixvim ];
        extraSpecialArgs = {
          inherit inputs;
          inherit theme;
          inherit browser;
          inherit font;
          inherit norgpkg;
        };
      };
    };
}
