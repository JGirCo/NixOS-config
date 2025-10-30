{ lib, pkgs, theme, browser, config, ... }:

let
  up = "k";
  down = "j";
  left = "h";
  right = "l";
  monitorHeight = 1600;
  monitorWidth = 2560;
  terminal = "ghostty";

  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

  startupScript = pkgs.writeShellScriptBin "startupScript" ''
    udiskie &
    keyd-application-mapper -d &
    swww-daemon &
    legion-kb-rgb set -e Static -c 100,100,100,100,100,100,100,100,100,100,100,100
    systemctl --user restart pipewire pipewire-pulse &
  '';

  reloadScript = pkgs.writeShellScriptBin "reloadScript" ''
    pkill waybar &
    sleep 0.2
    swww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any &
    waybar & disown
  '';

  prelockScript = pkgs.writeShellScriptBin "prelockScript" ''
    tmpbg="/tmp/screen.png"
    ${pkgs.grim}/bin/grim "$tmpbg"
    ${pkgs.imagemagick}/bin/magick "$tmpbg" -blur 0x5 -fill "#${colors.base}" -colorize 50% "$tmpbg"
  '';
in {
  programs.niri.enable = true;
  programs.niri.settings = {
  binds = with config.lib.niri.actions; {
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

    "Mod+D".action = spawn "fuzzel";
    "Mod+1".action = focus-workspace 1;

    "Mod+Shift+E".action = quit;
    "Mod+Ctrl+Shift+E".action = quit { skip-confirmation=true; };

    "Mod+Plus".action = set-column-width "+10%";
}

  };

}
