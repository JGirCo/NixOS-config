{
  description = "Home Manager configuration of jgirco";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    niri-animations = {
      url = "github:jgarza9788/niri-animation-collection";
      flake = false;
    };

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      nix-flatpak,
      walker,
      niri,
      zen-browser,
      ...
    }@inputs:
    let
      # System settings
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};

      # USER settings
      font = {
        name = "Maple Mono NF";
        isNF = false;
        sans = "Lexend deca";
        serif = "IBM Plex Serif";

      };
      browser = {
        name = "zen-twilight";
      };
      flake-overlays = [ niri.overlays.niri ];
      mkHomeConfig =
        themeName:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            { nixpkgs.overlays = flake-overlays; }
            ./home.nix
            nixvim.homeModules.nixvim
            walker.homeManagerModules.default
            niri.homeModules.niri
            zen-browser.homeModules.twilight-official
          ];
          extraSpecialArgs = {
            inherit inputs;
            theme = themeName;
            inherit browser;
            inherit font;
          };
        };
      themes = [
        "ayu-light"
        "catppuccin-latte"
        "catppuccin-macchiato"
        "dracula"
        "everforest-light"
        "gruvbox-dark-medium"
        "gruvbox-light-medium"
        "gruvbox-light-soft"
        "kanagawa-light"
        "melange"
        "oxocarbon-light"
        "rebecca"
        "rose-pine-dawn"
        "rose-pine"
        "saga"
        "template"
        "tokyo-night-moon"
        "trans"
      ];
    in
    {
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
      homeConfigurations = (lib.genAttrs themes (themeName: mkHomeConfig themeName)) // {
        "jgirco" = mkHomeConfig "catppuccin-macchiato";
      };
    };
}
