{
  rose-pine-dawn = {
    base = "#faf4ed";
    text = "#faf4ed";
    text2 = "#575279";
    inactive = "#d7827e";
    focused = "#b4637a";
    active = "#59949f";
    urgent = "#ea9d34";
    binding = "#907aa9";

    red = "#b4637a";
    yellow = "#ea9d34";
    pink = "#d7827e";
    green = "#59949f";
    blue = "#286983";
    purple = "#907aa9";

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
  gruvbox-dark-hard = {
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
}
