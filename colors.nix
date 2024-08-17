{ lib, theme }:

let colors = import ./colors/${theme}.nix;
in {
  nvimEngine = colors.nvimEngine or "builtin";
  isBase16Builtin = colors.isBase16Builtin or true;
} // colors
