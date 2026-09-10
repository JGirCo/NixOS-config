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
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:4evy/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake/6bb99ff875919f03ea6054026619d999061e1170";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minecraft-plymouth-theme = {
      url = "github:nikp123/minecraft-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wl_shimeji = {
      url = "git+https://github.com/CluelessCatBurger/wl_shimeji?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
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
      stylix,
      nixcord,
      ...
    }@inputs:
    let
      # System settings
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};

      # USER settings
      font = {
        mono = {
          name = "Maple Mono NF";
          package = pkgs.maple-mono.NF;
        };
        sans = {
          name = "Atkinson Hyperlegible Next";
          package = pkgs.atkinson-hyperlegible-next;
        };
        serif = {
          name = "IBM Plex Serif";
          package = pkgs.ibm-plex;
        };
      };
      browser = {
        name = "zen-twilight";
      };
      # Theme used for the system configuration and the default home config.
      defaultTheme = "catppuccin-macchiato";
      flake-overlays = [ niri.overlays.niri ];
      mkHomeConfig =
        themeName:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            { nixpkgs.overlays = flake-overlays; }
            ./home.nix
            nixvim.homeModules.nixvim
            stylix.homeModules.stylix
            nixcord.homeModules.nixcord
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
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix flake-overlays)
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            inputs.minegrub-world-sel-theme.nixosModules.default
            inputs.minecraft-plymouth-theme.nixosModules.default
          ];
          specialArgs = {
            inherit browser;
            inherit font;
            inherit inputs;
            theme = defaultTheme;
          };
        };
      };
      homeConfigurations = (lib.genAttrs themes (themeName: mkHomeConfig themeName)) // {
        "jgirco" = mkHomeConfig defaultTheme;
      };
    };
}
