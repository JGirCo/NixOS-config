{
  lib,
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
    };
    keybindings = {
      "alt+n" = "new_os_window_with_cwd";
      "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    };
  };
}
