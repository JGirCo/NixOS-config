{ theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = { buffer_selected = { bg = "#${colors.focused}"; }; };
  };
}
