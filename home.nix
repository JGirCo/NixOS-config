{ config, pkgs, nixvim, inputs, theme, lib, ... }:
let
  colors = import ./colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  imports = [

    ./zsh.nix
    # ./desktop/i3.nix
    ./desktop/hyprland.nix
    ./desktop/wofi.nix
    ./apps/wezterm.nix
    ./apps/kitty.nix
    ./desktop/gtk.nix
    ./neovim/default.nix
    # ./apps/spotifyd.nix
    ./apps/zathura.nix
    ./desktop/dunst.nix
    ./apps/cava.nix
    ./apps/freecad.nix
    ./apps/textfox.nix
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
  programs.home-manager.enable = true;
  home = {
    username = "jgirco";
    homeDirectory = "/home/jgirco";
    stateVersion = "23.11";
  };

}
