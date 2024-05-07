{ config, lib, pkgs, theme, font, ... }:

let
  mod = "Mod4";
  up = "k";
  down = "j";
  left = "h";
  right = "l";

  unfocused = "#ffffff00";
  focused_inactive = "#ffffff00";
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

in with colors; {
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    wbg # The only one that works consistently...
    waybar
    dunst
    wofi
    swayfx
    grim
    slurp
    imagemagick
    swappy
    wl-clipboard
  ];
  wayland.windowManager.hyprland = {
enable = true;
  };
}
