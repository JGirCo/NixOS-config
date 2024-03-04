{
  catppuccin-latte = {
    base = "#eff1f5";
    text = "#eff1f5";
    text2 = "#4c4f69";
    inactive = "#04a5e5";
    focused = "#1e66f5";
    active = "#179299";
    urgent = "#d20f39";
    binding = "#ea76cb";

    red = "#d20f39";
    yellow = "#df8e1d";
    pink = "#ea76cb";
    green = "#40a02b";
    blue = "#04a5e5";
    purple = "#8839ef";
    orange = "#fe640b";

    # base = "#${config.colorScheme.colors.base00}";
    # text = "#${config.colorScheme.colors.base00}";
    # inactive = "#${config.colorScheme.colors.base03}";
    # focused = "#${config.colorScheme.colors.base09}";
    # active = "#${config.colorScheme.colors.base0A}";
    # urgent = "#${config.colorScheme.colors.base08}";
    # binding = "#${config.colorScheme.colors.base0E}";

    key = {
      wezterm = "catppuccin-latte";
      nvim = "catppuccin";
      gtk = {
        iconsName = "rose-pine-dawn";
        iconsPackage = "rose-pine-icon-theme";
        cursorName = "phinger-cursors";
        cursorPackage = "phinger-cursors";
      };
    };
  };

  rose-pine-dawn = {
    base = "#faf4ed";
    text = "#faf4ed";
    text2 = "#575279";
    inactive = "#d7827e";
    focused = "#b4637a";
    active = "#56949f";
    urgent = "#ea9d34";
    binding = "#907aa9";

    red = "#b4637a";
    yellow = "#f6c177";
    pink = "#d7827e";
    green = "#56949f";
    blue = "#286983";
    purple = "#907aa9";
    orange = "#ea9d34";

    # base = "#${config.colorScheme.colors.base00}";
    # text = "#${config.colorScheme.colors.base00}";
    # inactive = "#${config.colorScheme.colors.base03}";
    # focused = "#${config.colorScheme.colors.base09}";
    # active = "#${config.colorScheme.colors.base0A}";
    # urgent = "#${config.colorScheme.colors.base08}";
    # binding = "#${config.colorScheme.colors.base0E}";

    key = {
      wezterm = "rose-pine-dawn";
      nvim = "rose-pine";
      gtk = {
        themeName = "rose-pine-dawn";
        themePackage = "rose-pine-gtk-theme";
        iconsName = "rose-pine-dawn";
        iconsPackage = "rose-pine-icon-theme";
        cursorName = "phinger-cursors";
        cursorPackage = "phinger-cursors";
      };
    };
  };

  rose-pine = {
    base = "#191224";
    text = "#191224";
    text2 = "#e0def4";
    inactive = "#ebbcba";
    focused = "#eb6f92";
    active = "#9ccfd8";
    urgent = "#ea9d34";
    binding = "#c4a7e7";

    red = "#eb6f92";
    yellow = "#f6c177";
    pink = "#ebbcba";
    green = "#9ccfd8";
    blue = "#31748f";
    purple = "#c4a7e7";
    orange = "#ea9d34";

    # base = "#${config.colorScheme.colors.base00}";
    # text = "#${config.colorScheme.colors.base00}";
    # inactive = "#${config.colorScheme.colors.base03}";
    # focused = "#${config.colorScheme.colors.base09}";
    # active = "#${config.colorScheme.colors.base0A}";
    # urgent = "#${config.colorScheme.colors.base08}";
    # binding = "#${config.colorScheme.colors.base0E}";

    key = {
      wezterm = "rose-pine";
      nvim = "rose-pine";
      gtk = {
        themeName = "rose-pine";
        themePackage = "rose-pine-gtk-theme";
        iconsName = "rose-pine";
        iconsPackage = "rose-pine-icon-theme";
        cursorName = "phinger-cursors";
        cursorPackage = "phinger-cursors";
      };
    };
  };
  dracula = {
    base = "#282a36";
    text = "#282a36";
    text2 = "#f8f8f2";
    inactive = "#6272a4";
    focused = "#bd93f9";
    active = "#50fa7b";
    urgent = "#ff5555";
    binding = "#ff79c6";

    red = "#ff5555";
    yellow = "#f1fa8c";
    pink = "#ff79c6";
    green = "#50fa7b";
    blue = "#8be9fd";
    purple = "#bd93f9";
    orange = "#ffb86c";

    key = {
      wezterm = "Dracula";
      nvim = "dracula";
      gtk = {
        themeName = "Dracula";
        themePackage = "dracula-theme";
        iconsName = "dracula";
        iconsPackage = "dracula-icon-theme";
        cursorName = "Dracula-cursors";
        cursorPackage = "phinger-cursors";
      };
    };
  };
  gruvbox-dark-medium = {
    base = "#282828";
    text = "#282828";
    text2 = "#ebdbb2";
    inactive = "#458588";
    focused = "#83a598";
    active = "#8ec07e";
    urgent = "#fb4934";
    binding = "#d3869b";

    red = "#fb4934";
    yellow = "#fabd2f";
    pink = "#d3869b";
    green = "#b8bb26";
    blue = "#83a598";
    purple = "#d3869b";
    orange = "#f38019";

    key = {
      wezterm = "Gruvbox Dark (Gogh)";
      nvim = "gruvbox";
      gtk = {
        themeName = "gruvbox-dark";
        themePackage = "gruvbox-dark-gtk";
        iconsName = "oomox-gruvbox-dark";
        iconsPackage = "gruvbox-dark-icons-gtk";
        cursorName = "Capitaine Cursors (Gruvbox) - White";
        cursorPackage = "capitaine-cursors-themed";
      };
    };
  };

  gruvbox-light-medium = {
    base = "#fbf1c7";
    text = "#fbf1c7";
    text2 = "#3c3836";
    inactive = "#689d6a";
    focused = "#427b58";
    active = "#427b58";
    urgent = "#9d0006";
    binding = "#8f3f71";

    red = "#cc241d";
    yellow = "#d79921";
    pink = "#b16286";
    green = "#79740e";
    blue = "#458588";
    purple = "#8f3f71";
    orange = "#f38019";

    key = {
      wezterm = "GruvboxLight";
      nvim = "gruvbox";
      gtk = {
        themeName = "gruvbox-light";
        themePackage = "gruvbox-gtk-theme";
        iconsName = "oomox-gruvbox-dark";
        iconsPackage = "gruvbox-dark-icons-gtk";
        cursorName = "Capitaine Cursors (Gruvbox)";
        cursorPackage = "capitaine-cursors-themed";
      };
    };
  };
}
