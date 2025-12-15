{ config, pkgs, nixvim, inputs, theme, lib, ... }:
let
  colors = import ./colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  imports = [

    ./zsh.nix
    ./desktop/hyprland.nix
    ./desktop/wofi.nix
    ./desktop/gtk.nix
    ./desktop/dunst.nix
    # ./desktop/niri.nix

    ./apps/wezterm.nix
    ./apps/kitty.nix
    ./apps/zen.nix

    ./neovim/default.nix

    ./apps/zathura.nix
    ./apps/ghostty.nix
    ./apps/tmux.nix
    ./apps/cava.nix
    ./apps/directwrite/keyd-application-mapper.nix
    ./apps/directwrite/tridactyl.nix
    ./apps/directwrite/darkreader.nix
    ./apps/directwrite/blockbench.nix

    ./scripts/default.nix

    inputs.nix-colors.homeManagerModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  colorScheme = if colors.isBase16Builtin then
    inputs.nix-colors.colorSchemes.${theme}
  else {
    slug = "pasque";
    name = "Pasque";
    author = "Gabriel Fontes (https://github.com/Misterio77)";
    palette = with colors.base16; {
      inherit base00;
      inherit base01;
      inherit base02;
      inherit base03;
      inherit base04;
      inherit base05;
      inherit base06;
      inherit base07;
      inherit base08;
      inherit base09;
      inherit base0A;
      inherit base0B;
      inherit base0C;
      inherit base0D;
      inherit base0E;
      inherit base0F;
    };
  };

  _module.args.colors = colors;

  programs.home-manager.enable = true;
  home = {
    username = "jgirco";
    homeDirectory = "/home/jgirco";
    stateVersion = "23.11";
  };

}
