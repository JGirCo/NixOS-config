{
  rose-pine-dawn = {
    base = "#faf4ed";
    text = "#faf4ed";
    inactive = "#d7827e";
    focused = "#b4637a";
    active = "#59949f";
    urgent = "#ea9d34";
    binding = "#907aa9";

    # base = "#${config.colorScheme.colors.base00}";
    # text = "#${config.colorScheme.colors.base00}";
    # inactive = "#${config.colorScheme.colors.base03}";
    # focused = "#${config.colorScheme.colors.base09}";
    # active = "#${config.colorScheme.colors.base0A}";
    # urgent = "#${config.colorScheme.colors.base08}";
    # binding = "#${config.colorScheme.colors.base0E}";

    key = {
      wezterm = "rose-pine-dawn";
      nvim = "rose-pine-dawn";
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
    inactive = "#6272a4";
    focused = "#bd93f9";
    active = "#50fa7b";
    urgent = "#ff5555";
    binding = "#ff79c6";

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
    inactive = "#458588";
    focused = "#83a598";
    active = "#8ec07e";
    urgent = "#fb4934";
    binding = "#d3869b";

    key = {
      wezterm = "Gruvbox Dark (Gogh)";
      nvim = "gruvbox-dark-hard";
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
