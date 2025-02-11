{ config, pkgs, lib, theme, font, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

  cssContent = with config.colorScheme.palette;
    with colors; ''
      @define-color accent_color #${base0D};
      @define-color accent_bg_color mix(#${base0D}, #${base},0.3);
      @define-color accent_fg_color #${base};
      @define-color destructive_color #${base0C};
      @define-color destructive_bg_color mix(#${base0C}, #${base},0.3);
      @define-color destructive_fg_color #${base02};
      @define-color success_color #${base0B};
      @define-color success_bg_color mix(#${base0B}, black,0.6);
      @define-color success_fg_color #${base02};
      @define-color warning_color #${base0A};
      @define-color warning_bg_color mix(#${base0A}, black,0.6);
      @define-color warning_fg_color rgba(0, 0, 0, 0.8);
      @define-color error_color #${base08};
      @define-color error_bg_color mix(#${base0C}, #${base},0.3);
      @define-color error_fg_color #${base02};
      @define-color window_bg_color mix(#${focused}, #${base}, 0.92);
      @define-color window_fg_color #${text2};
      @define-color view_bg_color #${base01};
      @define-color view_fg_color #${text2};
      @define-color sidebar_fg_color #${text2};
      @define-color sidebar_bg_color #${base};
      @define-color sidebar_backdrop_color #${base};
      @define-color headerbar_bg_color #${base};
      @define-color headerbar_fg_color #${text2};
      @define-color headerbar_border_color #${base02};
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
      @define-color card_bg_color rgba(255, 255, 255, 0.08);
      @define-color card_fg_color #${text2};
      @define-color card_shade_color rgba(0, 0, 0, 0.36);
      @define-color dialog_bg_color #${base02};
      @define-color dialog_fg_color #${text2};
      @define-color popover_bg_color #${base02};
      @define-color popover_fg_color #${text2};
      @define-color shade_color rgba(0,0,0,0.36);
      @define-color scrollbar_outline_color rgba(0,0,0,0.5);
      @define-color blue_1 #${base0D};
      @define-color blue_2 #${base0D};
      @define-color blue_3 #${base0D};
      @define-color blue_4 #${base0D};
      @define-color blue_5 #${base0D};
      @define-color green_1 #${base0B};
      @define-color green_2 #${base0B};
      @define-color green_3 #${base0B};
      @define-color green_4 #${base0B};
      @define-color green_5 #${base0B};
      @define-color yellow_1 #${base0A};
      @define-color yellow_2 #${base0A};
      @define-color yellow_3 #${base0A};
      @define-color yellow_4 #${base0A};
      @define-color yellow_5 #${base0A};
      @define-color orange_1 #${base09};
      @define-color orange_2 #${base09};
      @define-color orange_3 #${base09};
      @define-color orange_4 #${base09};
      @define-color orange_5 #${base09};
      @define-color red_1 #${base08};
      @define-color red_2 #${base08};
      @define-color red_3 #${base08};
      @define-color red_4 #${base08};
      @define-color red_5 #${base08};
      @define-color purple_1 #${base0E};
      @define-color purple_2 #${base0E};
      @define-color purple_3 #${base0E};
      @define-color purple_4 #${base0E};
      @define-color purple_5 #${base0E};
      @define-color brown_1 #${base0F};
      @define-color brown_2 #${base0F};
      @define-color brown_3 #${base0F};
      @define-color brown_4 #${base0F};
      @define-color brown_5 #${base0F};
      @define-color light_1 #${base02};
      @define-color light_2 #f6f5f4;
      @define-color light_3 #deddda;
      @define-color light_4 #c0bfbc;
      @define-color light_5 #9a9996;
      @define-color dark_1 mix(#${base},white,0.5);
      @define-color dark_2 mix(#${base},white,0.2);
      @define-color dark_3 #${base};
      @define-color dark_4 mix(#${base},black,0.2);
      @define-color dark_5 mix(#${base},black,0.4);
    '';

in {
  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    theme.package = pkgs.adw-gtk3;
    iconTheme.name = "Papirus";
    iconTheme.package = pkgs.papirus-icon-theme;

    font = {
      size = 12;
      name = "${font.name}";
      # package = pkgs.${font.pkg};
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt6;
  };

  home.sessionVariables = { QT_STYLE_OVERRIDE = "adwaita-dark"; };
  home.packages = [ pkgs.adwaita-qt6 ];
  # detected automatically:
  # adwaita, adwaita-dark, adwaita-highcontrast,
  # adwaita-highcontrastinverse, breeze,
  # bb10bright, bb10dark, cde, cleanlooks,
  # gtk2, motif, plastique

  # package to use

  xdg.configFile."gtk-4.0/gtk.css" = { text = cssContent; };
  xdg.configFile."gtk-3.0/gtk.css" = { text = cssContent; };
}
