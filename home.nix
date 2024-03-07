{ config, pkgs, nixvim, inputs, theme, lib, ... }:

{
  imports =
    [
      ./zsh.nix
      # ./desktop/i3.nix
      ./desktop/sway.nix
      ./apps/wezterm.nix
      ./desktop/gtk.nix
      ./neovim/default.nix
      ./apps/spotifyd.nix
      ./apps/zathura.nix
      inputs.nix-colors.homeManagerModules.default
    ];

    colorScheme = inputs.nix-colors.colorSchemes.${theme};

    home.username = "juanma";
    home.homeDirectory = "/home/juanma";
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
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
