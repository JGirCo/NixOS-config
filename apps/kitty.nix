{
  config,
  lib,
  pkgs,
  theme,
  font,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit config lib colors;
  };
in
{
  programs.kitty = {
    enable = true;
    font.name = font.name;
    font.size = 16;
    shellIntegration.enableZshIntegration = true;
    settings = {
      foreground = themeLib.terminal.fg;
      background = themeLib.terminal.bg;
      background_tint = 0;
      selection_fg = themeLib.terminal.selectionFg;
      selection_bg = themeLib.terminal.selectionBg;

      color0 = themeLib.terminal.colors.black;
      color1 = themeLib.terminal.colors.red;
      color2 = themeLib.terminal.colors.green;
      color3 = themeLib.terminal.colors.yellow;
      color4 = themeLib.terminal.colors.blue;
      color5 = themeLib.terminal.colors.magenta;
      color6 = themeLib.terminal.colors.cyan;
      color7 = themeLib.terminal.colors.white;

      color8 = themeLib.terminal.brights.black;
      color9 = themeLib.terminal.brights.red;
      color10 = themeLib.terminal.brights.green;
      color11 = themeLib.terminal.brights.yellow;
      color12 = themeLib.terminal.brights.blue;
      color13 = themeLib.terminal.brights.magenta;
      color14 = themeLib.terminal.brights.cyan;
      color15 = themeLib.terminal.brights.white;

      enable_audio_bell = "no";
      confirm_os_window_close = 0;
    };
    keybindings = {
      "alt+n" = "new_os_window_with_cwd";
      "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    };
  };
}
