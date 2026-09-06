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

      notify_on_cmd_finish = "never";
      window_alert_on_bell = "no";
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/mykitty";
      background_opacity = lib.mkForce "0.85";
    };
    keybindings = {
      "alt+n" = "new_os_window_with_cwd";
      "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    };

  };

  # programs.zellij = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   settings = {
  #     support_kitty_keyboard_protocol = true;
  #     default_layout = "compact";
  #     pane_frames = false;
  #     show_startup_tips = false;
  #     keybinds = {
  #       normal = {
  #         "bind \"Alt space\"" = {
  #           EditScrollback = [ ];
  #         };
  #         "bind \"Alt n\"" = {
  #           NewTab = [ ];
  #         };
  #       };
  #     };
  #   };
  # };

}
