{
  config,
  pkgs,
  nixvim,
  inputs,
  theme,
  lib,
  ...
}:
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  systemd.user.services = {
    # Background Daemons

    iwgtk = {
      Unit = {
        Description = "iwd wireless GUI tray indicator";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.iwgtk}/bin/iwgtk -i";
        Restart = "on-failure";
        RestartSec = "3";
      };
    };

    # Background Daemons

    awww-daemon = {
      Unit.Description = "Wayland wallpaper daemon";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
        RestartSec = "1";
      };
    };

    udiskie = {
      Unit.Description = "Removable disk automounter";
      Service.ExecStart = "${pkgs.udiskie}/bin/udiskie";
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # Input & Keyboard
    keyd-mapper = {
      Unit.Description = "Keyd application mapper";
      Service = {
        ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
        Restart = "on-failure";
        RestartSec = "1";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # UI Elements
    waybar = {
      Unit.Description = "Wayland status bar";
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "always";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # mpris-notifier = {
    #   Unit.Description = "MPRIS Notifier";
    #   Service = {
    #     ExecStart = "${pkgs.mpris-notifier}/bin/mpris-notifier";
    #     Restart = "on-failure";
    #   };
    #   Install.WantedBy = [ "graphical-session.target" ];
    # };
    swayosd = {
      Service.X-RestartIfChanged = true;
      Unit = {
        After = [ "graphical-session.target" ];
        ConditionEnvironment = lib.mkForce "";
      };
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
    apply-theme = {
      Unit.Description = "Apply Niri theme and wallpaper";
      Install.WantedBy = [ "xdg-desktop-autostart.target" ];
      Service = {
        RemainAfterExit = true;
        Type = "oneshot";
        X-RestartIfChanged = true;
        ExecStart = "${pkgs.writeShellScript "apply-theme-script" ''
          niri msg action load-config-file
          sleep 0.2
          systemctl --user restart --no-block swayosd.service
          uwsm app -- ${pkgs.awww}/bin/awww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any
        ''}";
      };
    };
  };

}
