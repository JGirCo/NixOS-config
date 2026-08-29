{
  config,
  pkgs,
  nixvim,
  inputs,
  theme,
  lib,
  ...
}:

let
  mkSymlinkDaemon =
    {
      name,
      directory,
      findArgs,
    }:
    {
      systemd.user.services."sync-${name}-symlinks" = {
        Unit.Description = "Symlink dynamic criteria from ${directory} to Desktop/${name}";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "sync-${name}-symlinks" ''
            target="${config.home.homeDirectory}/Desktop/${name}"
            ${pkgs.coreutils}/bin/mkdir -p "$target"

            # 1. Purge broken symlinks in the target directory
            # '-type l' looks for symlinks, '! -exec test -e {} \;' checks if the target is missing
            ${pkgs.findutils}/bin/find "$target" -type l -delete

            # 2. Find and link the files matching your criteria
            # -print0 and xargs -0 safely handle filenames with spaces or weird characters
            ${pkgs.findutils}/bin/find "${directory}" -maxdepth 1 -type f ${findArgs} -print0 | \
              ${pkgs.findutils}/bin/xargs -0 -r -I {} ${pkgs.coreutils}/bin/ln -sf {} "$target/"
          ''}";
        };
      };

      systemd.user.paths."sync-${name}-symlinks" = {
        Unit.Description = "Watch ${directory} for ${name} files";
        Path = {
          # PathChanged fires on file creation, modification, and deletion
          PathChanged = directory;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
in
lib.mkMerge [
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
  (mkSymlinkDaemon {
    name = "RecentDownloads";
    directory = "${config.home.homeDirectory}/Downloads";
    findArgs = "-mmin -60";
  })

  (mkSymlinkDaemon {
    name = "CVs";
    directory = "${config.home.homeDirectory}/Documents/hoja-de-vida";
    findArgs = "-name '*.pdf'";
  })
]
