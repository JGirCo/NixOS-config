{ config, pkgs, ... }:

{
  imports =
    [
      ./zsh.nix
      ./desktop/i3.nix
      ./desktop/picom.nix
      ./desktop/wezterm.nix
    ];
    home.username = "juanma";
    home.homeDirectory = "/home/juanma";
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
    home.packages = with pkgs; [
      rofi
      i3blocks
      i3lock
      picom
      feh
      dunst
      lxappearance
    ];
    programs.zoxide.enable = true;

    # systemd services

    systemd.user.services."battery-notifier" = {
      Unit = {
        Description = "Systemd user service template";
      };
      Service = {
        Type = "oneshot";
        ExecStart = toString (
          pkgs.writeShellScript "battery-notifier-script" ''
            set -eou pipefail
            ${pkgs.bash}/bin/bash "/home/juanma/.local/bin/batteryIndicator";
          ''
        );
      };
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.timers."battery-notifier" = {
      Unit = {
        Description = "sysdtimer template";
      };
      Timer = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "battery-notifier";
      };
      Install.WantedBy = [ "timers.target" ];
    };
}
