{ config, pkgs, nixvim, theme,... }:

let
  color_scheme = import ./colors.nix;
in

with color_scheme.${theme}.key.gtk;{
    gtk.enable = true;

    gtk.theme.name = "${themeName}";
    gtk.theme.package = pkgs."${themePackage}";

    gtk.iconTheme.package = pkgs."${iconsPackage}";
    gtk.iconTheme.name = "${iconsName}";

    home.pointerCursor = {
      name = "${cursorName}";
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = "${cursorName}";
      package = pkgs."${cursorPackage}";
    };
}
