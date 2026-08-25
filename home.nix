{
  config,
  pkgs,
  nixvim,
  inputs,
  theme,
  lib,
  ...
}:

let
  themes = import ./themes.nix;
  themeColors = themes.${theme} or themes."catppuccin-macchiato";
  colors = themeColors
    // {
      nvimEngine = themeColors.nvimEngine or "builtin";
      isBase16Builtin = themeColors.isBase16Builtin or true;
    };
in
{
  imports = [

    ./home-services.nix
    ./zsh.nix
    # ./apps/opencode.nix
    # ./desktop/hyprland.nix
    # ./desktop/wofi.nix
    # ./desktop/rofi.nix
    ./desktop/stylix.nix
    ./desktop/walker.nix
    ./desktop/dunst.nix
    ./desktop/niri.nix
    ./desktop/niri-animations.nix

    ./apps/wezterm.nix
    ./apps/kitty.nix
    ./apps/zen.nix

    ./neovim/default.nix

    ./apps/zathura.nix
    ./apps/tmux.nix
    # ./apps/ghostty.nix
    ./apps/cava.nix
    ./apps/directwrite/keyd-application-mapper.nix
    ./apps/directwrite/tridactyl.nix
    # ./apps/directwrite/darkreader.nix
    # ./apps/directwrite/blockbench.nix

    ./scripts/default.nix

    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  _module.args.colors = colors;

  programs.home-manager.enable = true;
  home = {
    username = "jgirco";
    homeDirectory = "/home/jgirco";
    stateVersion = "23.11";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
  home.packages = with pkgs; [

    #GUI
    freecad-wayland
    mangohud
    celluloid
    gparted
    yt-dlp
    parabolic
    # discord
    darktable
    bottles
    lutris
    vlc

    #TUI
    bitwarden-cli
    cava
    yazi-unwrapped
    wiremix
    lazygit
    bottom
    bluetui
    pulsemixer
    skyscraper
  ];
}