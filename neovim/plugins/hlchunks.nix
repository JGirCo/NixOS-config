{ config, theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  programs.nixvim.plugins.hlchunk = {
    enable = true;
    settings = {
      chunk = {
        enable = true;
        use_treesitter = true;
        style = "#${colors.alt}";
        delay = 0;

      };
    };
  };
}
