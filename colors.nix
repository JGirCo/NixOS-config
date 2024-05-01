{ lib, theme }:

let colors = import ./colors/${theme}.nix;
in {
  isNvimBuiltin = colors.isNvimBuiltin or true;

  isBase16Builtin = colors.isBase16Builtin or true;
} // colors
