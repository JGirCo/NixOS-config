{
  config,
  lib,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit config lib colors;
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
