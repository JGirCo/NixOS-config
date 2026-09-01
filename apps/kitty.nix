{
  config,
  lib,
  pkgs,
  theme,
  font,
  colors,
  ...
}:

{
  programs.kitty = {
    enable = true;
    font.size = lib.mkForce 16;
    shellIntegration.enableZshIntegration = true;
    settings = {
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
    };
    keybindings = {
      "alt+n" = "new_os_window_with_cwd";
      "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    };
  };
}
