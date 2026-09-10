# Resolve a theme entry from themes.nix into the options stylix expects.
{ pkgs, themes }:
themeName:
let
  themeColors = themes.${themeName} or themes."catppuccin-macchiato";
  scheme = themeColors.scheme;
in
{
  inherit (themeColors) polarity;
  base16Scheme =
    if scheme ? file then "${pkgs.base16-schemes}/share/themes/${scheme.file}.yaml" else scheme.palette;
  override = scheme.override or { };
}
