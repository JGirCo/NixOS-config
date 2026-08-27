# User account definition, plus session/power management:
# logind lid-switch + power-key behavior, xss-lock screen lock, sleep policy,
# and PAM service for gtklock.
{ pkgs, lib, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jgirco = {
    isNormalUser = true;
    description = "Juan Manuel Giraldo";
    extraGroups = [
      "input"
      "uinput"
      "render"
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "input"
      "keyd"
      "sensors"
      "audio"
    ];
    shell = pkgs.zsh;
  };

  services.logind.settings.Login = {
    # never suspend when the lid is closed
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    # hibernate when the power button is short-pressed
    HandlePowerKey = lib.mkDefault "hibernate";
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.gtklock}/bin/gtklock";
  };

  security.pam.services = {
    gtklock = { };
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowSuspendThenHibernate = "yes";
  };
}
