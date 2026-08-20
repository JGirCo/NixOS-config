{
  config,
  pkgs,
  lib,
  theme,
  font,
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
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = colors.key.darklight or "prefer-dark";
    };
  };

  gtk = {
    gtk4.theme = null;
    enable = true;
    theme.name = "adw-gtk3";
    theme.package = pkgs.adw-gtk3;
    iconTheme.name = "Qogir";
    iconTheme.package = pkgs.qogir-icon-theme;

    font = {
      size = 16;
      name = font.sans;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugins
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORMTHEME_6 = "qt6ct";
  };

  xdg.configFile."gtk-4.0/gtk.css".text = themeLib.gtkCss;
  xdg.configFile."gtk-3.0/gtk.css".text = themeLib.gtkCss;
  xdg.configFile."qt5ct/colors/Custom.conf".text = ''
    [ColorScheme]
    active_colors=${themeLib.qt.activeColors}
    disabled_colors=${themeLib.qt.disabledColors}
    inactive_colors=${themeLib.qt.inactiveColors}
  '';
  xdg.configFile."qt6ct/colors/Custom.conf".text = ''
    [ColorScheme]
    active_colors=${themeLib.qt.activeColors}
    disabled_colors=${themeLib.qt.disabledColors}
    inactive_colors=${themeLib.qt.inactiveColors}
  '';
}
