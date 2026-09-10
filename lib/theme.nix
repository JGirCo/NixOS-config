{
  config,
  lib,
  colors,
}:

let
  palette = config.lib.stylix.colors;

  # Normalise colours so we always produce #rrggbb, regardless of whether the
  # input already included a hash.
  hex =
    c:
    let
      s = toString c;
    in
    if lib.hasPrefix "#" s then lib.substring 1 (-1) s else s;
  withHash = c: "#${hex c}";

  # Semantic aliases for the expressive colours defined per theme in themes.nix.
  semantic = {
    bg = withHash (colors.base or palette.base00);
    fg = withHash (colors.text or palette.base05);
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
  base16 = palette.withHashtag;

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
in
{
  inherit
    semantic
    terminal
    cavaGradient
    ;
}
