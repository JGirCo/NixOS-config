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
  systemd.user.services = {
    # Background Daemons

    # Put these alongside your other top-level Home Manager configurations
    services.swaync.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = true; # Adds the tray icon if you want it
    };
    swww-daemon = {
      Unit.Description = "Wayland wallpaper daemon";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
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
  };

}
