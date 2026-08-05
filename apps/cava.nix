{
  config,
  lib,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit lib colors;
    palette = config.colorScheme.palette;
  };
in
{
  programs.cava = {
    enable = true;
    settings = {
      color = themeLib.cavaGradient;
    };
  };
}
