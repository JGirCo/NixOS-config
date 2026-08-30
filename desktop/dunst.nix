{
  lib,
  theme,
  font,
  pkgs,
  config,
  colors,
  ...
}:
with colors;
with config.lib.stylix.colors;
{
  home.packages = [ pkgs.libnotify ]; # to enable notify-send
}
