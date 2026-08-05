# Central theme helper: derive common app configs from the semantic palette
# and the base16 palette.
{
  lib,
  colors,
  palette,
}:
let
  # Normalise colours so we always produce #rrggbb, regardless of whether the
  # input already included a hash.
  hex =
    c:
    let
      s = toString c;
    in
    if lib.hasPrefix "#" s then lib.substring 1 (-1) s else s;
  withHash = c: "#${hex c}";

  # Semantic aliases for the expressive colours you define in colors/*.nix.
  semantic = {
    bg = withHash (colors.base or palette.base00);
    fg = withHash (colors.text2 or palette.base05);
    text = withHash (colors.text or palette.base07);
    accent = withHash (colors.focused or palette.base0D);
    secondary = withHash (colors.inactive or palette.base0E);
    alt = withHash (colors.alt or palette.base0A);
    urgent = withHash (colors.urgent or palette.base08);
    binding = withHash (colors.binding or palette.base0C);
    red = withHash (colors.red or palette.base08);
    yellow = withHash (colors.yellow or palette.base0A);
    green = withHash (colors.green or palette.base0B);
    blue = withHash (colors.blue or palette.base0D);
    purple = withHash (colors.purple or palette.base0E);
    orange = withHash (colors.orange or palette.base09);
    pink = withHash (colors.pink or palette.base0E);
  };

  # Base16 colours, guaranteed to carry a leading #.
  base16 = lib.mapAttrs (_: withHash) palette;

  # Shared 16-colour terminal palette.
  terminal = {
    fg = base16.base05;
    bg = base16.base00;
    selectionFg = base16.base05;
    selectionBg = base16.base02;
    cursor = base16.base05;
    cursorText = base16.base00;

    colors = {
      black = base16.base00;
      red = base16.base08;
      green = base16.base0B;
      yellow = base16.base09;
      blue = base16.base0D;
      magenta = base16.base0E;
      cyan = base16.base0C;
      white = base16.base06;
    };

    brights = {
      black = base16.base03;
      red = base16.base08;
      green = base16.base0B;
      yellow = base16.base0A;
      blue = base16.base0D;
      magenta = base16.base0E;
      cyan = base16.base0C;
      white = base16.base05;
    };

    all = lib.attrValues terminal.colors ++ lib.attrValues terminal.brights;
  };

  # Cava gradient, mapped to base16 accents so every theme feels colourful.
  cavaGradient = {
    gradient = "1";
    gradient_count = "7";
    gradient_color_7 = "'${base16.base0E}'";
    gradient_color_6 = "'${base16.base08}'";
    gradient_color_5 = "'${base16.base09}'";
    gradient_color_4 = "'${base16.base0A}'";
    gradient_color_3 = "'${base16.base0B}'";
    gradient_color_2 = "'${base16.base0C}'";
    gradient_color_1 = "'${base16.base0D}'";
  };

  gtkCss = ''
    @define-color accent_color ${base16.base0D};
    @define-color accent_bg_color mix(${base16.base0D}, ${semantic.bg},0.3);
    @define-color accent_fg_color ${base16.base02};
    @define-color destructive_color ${base16.base0C};
    @define-color destructive_bg_color mix(${base16.base0C}, ${semantic.bg},0.3);
    @define-color destructive_fg_color ${base16.base02};
    @define-color success_color ${base16.base0B};
    @define-color success_bg_color mix(${base16.base0B}, black,0.6);
    @define-color success_fg_color ${base16.base02};
    @define-color warning_color ${base16.base0A};
    @define-color warning_bg_color mix(${base16.base0A}, black,0.6);
    @define-color warning_fg_color rgba(0, 0, 0, 0.8);
    @define-color error_color ${base16.base08};
    @define-color error_bg_color mix(${base16.base0C}, ${semantic.bg},0.3);
    @define-color error_fg_color ${base16.base02};
    @define-color window_bg_color mix(${semantic.accent}, ${semantic.bg}, 0.92);
    @define-color window_fg_color ${semantic.fg};
    @define-color view_bg_color ${base16.base01};
    @define-color view_fg_color ${semantic.fg};
    @define-color sidebar_fg_color ${semantic.fg};
    @define-color sidebar_bg_color ${semantic.bg};
    @define-color sidebar_backdrop_color ${semantic.bg};
    @define-color headerbar_bg_color ${semantic.bg};
    @define-color headerbar_fg_color ${semantic.fg};
    @define-color headerbar_border_color ${base16.base02};
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
    @define-color card_bg_color rgba(255, 255, 255, 0.08);
    @define-color card_fg_color ${semantic.fg};
    @define-color card_shade_color rgba(0, 0, 0, 0.36);
    @define-color dialog_bg_color ${base16.base02};
    @define-color dialog_fg_color ${semantic.fg};
    @define-color popover_bg_color ${base16.base02};
    @define-color popover_fg_color ${semantic.fg};
    @define-color shade_color rgba(0,0,0,0.36);
    @define-color scrollbar_outline_color rgba(0,0,0,0.5);
    @define-color blue_1 ${base16.base0D};
    @define-color blue_2 ${base16.base0D};
    @define-color blue_3 ${base16.base0D};
    @define-color blue_4 ${base16.base0D};
    @define-color blue_5 ${base16.base0D};
    @define-color green_1 ${base16.base0B};
    @define-color green_2 ${base16.base0B};
    @define-color green_3 ${base16.base0B};
    @define-color green_4 ${base16.base0B};
    @define-color green_5 ${base16.base0B};
    @define-color yellow_1 ${base16.base0A};
    @define-color yellow_2 ${base16.base0A};
    @define-color yellow_3 ${base16.base0A};
    @define-color yellow_4 ${base16.base0A};
    @define-color yellow_5 ${base16.base0A};
    @define-color orange_1 ${base16.base09};
    @define-color orange_2 ${base16.base09};
    @define-color orange_3 ${base16.base09};
    @define-color orange_4 ${base16.base09};
    @define-color orange_5 ${base16.base09};
    @define-color red_1 ${base16.base08};
    @define-color red_2 ${base16.base08};
    @define-color red_3 ${base16.base08};
    @define-color red_4 ${base16.base08};
    @define-color red_5 ${base16.base08};
    @define-color purple_1 ${base16.base0E};
    @define-color purple_2 ${base16.base0E};
    @define-color purple_3 ${base16.base0E};
    @define-color purple_4 ${base16.base0E};
    @define-color purple_5 ${base16.base0E};
    @define-color brown_1 ${base16.base0F};
    @define-color brown_2 ${base16.base0F};
    @define-color brown_3 ${base16.base0F};
    @define-color brown_4 ${base16.base0F};
    @define-color brown_5 ${base16.base0F};
    @define-color light_1 ${base16.base02};
    @define-color light_2 #f6f5f4;
    @define-color light_3 #deddda;
    @define-color light_4 #c0bfbc;
    @define-color light_5 #9a9996;
    @define-color dark_1 mix(${semantic.bg},white,0.5);
    @define-color dark_2 mix(${semantic.bg},white,0.2);
    @define-color dark_3 ${semantic.bg};
    @define-color dark_4 mix(${semantic.bg},black,0.2);
    @define-color dark_5 mix(${semantic.bg},black,0.4);
  '';

  # Qt5ct / Qt6ct palette generator.
  qt =
    let
      # Order mandated by Qt for palette entries:
      # WindowText, Button, Light, Midlight, Dark, Mid,
      # Text, BrightText, ButtonText, Base, Window, Shadow,
      # Highlight, HighlightedText, Link, LinkVisited,
      # AlternateBase, NoRole, ToolTipBase, ToolTipText, PlaceholderText
      active = [
        base16.base05 # Window text
        base16.base02 # Button background
        base16.base01 # Light
        base16.base02 # Midlight
        base16.base03 # Dark
        base16.base02 # Mid
        base16.base05 # Normal text
        base16.base00 # Bright text
        base16.base05 # Button text
        base16.base00 # Base (editable background)
        base16.base00 # Window background
        base16.base03 # Shadow
        semantic.accent # Highlight
        base16.base00 # Highlighted text
        base16.base0D # Link
        base16.base0E # Visited link
        base16.base01 # Alternate background
        base16.base00 # NoRole
        base16.base02 # Tooltip background
        base16.base05 # Tooltip text
        base16.base04 # Placeholder text
      ];

      disabled = [
        base16.base04 # Window text
        base16.base02 # Button background
        base16.base03 # Light
        base16.base04 # Midlight
        base16.base04 # Dark
        base16.base03 # Mid
        base16.base04 # Normal text
        base16.base03 # Bright text
        base16.base04 # Button text
        base16.base01 # Base
        base16.base01 # Window background
        base16.base04 # Shadow
        semantic.secondary # Highlight
        base16.base03 # Highlighted text
        base16.base0D # Link
        base16.base0E # Visited link
        base16.base02 # Alternate background
        base16.base03 # NoRole
        base16.base02 # Tooltip background
        base16.base04 # Tooltip text
        base16.base04 # Placeholder text
      ];

      formatColors = colors: lib.concatStringsSep "," colors;
    in
    {
      activeColors = formatColors active;
      disabledColors = formatColors disabled;
      inactiveColors = formatColors active;
    };
in
{
  inherit
    semantic
    terminal
    cavaGradient
    gtkCss
    qt
    ;
}
