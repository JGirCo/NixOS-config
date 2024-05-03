{ config, pkgs, nixvim, inputs, theme, lib, ... }:
let
  colors = import ./colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  imports = [

    ./zsh.nix
    # ./desktop/i3.nix
    ./desktop/sway.nix
    ./desktop/wofi.nix
    ./apps/wezterm.nix
    ./desktop/gtk.nix
    ./neovim/default.nix
    # ./apps/spotifyd.nix
    ./apps/zathura.nix
    ./desktop/dunst.nix
    ./apps/cava.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = if colors.isBase16Builtin then
    inputs.nix-colors.colorSchemes.${theme}
  else {
    slug = "pasque";
    name = "Pasque";
    author = "Gabriel Fontes (https://github.com/Misterio77)";
    palette = {
      base00 = colors.base16.base00;
      base01 = colors.base16.base01;
      base02 = colors.base16.base02;
      base03 = colors.base16.base03;
      base04 = colors.base16.base04;
      base05 = colors.base16.base05;
      base06 = colors.base16.base06;
      base07 = colors.base16.base07;
      base08 = colors.base16.base08;
      base09 = colors.base16.base09;
      base0A = colors.base16.base0A;
      base0B = colors.base16.base0B;
      base0C = colors.base16.base0C;
      base0D = colors.base16.base0D;
      base0E = colors.base16.base0E;
      base0F = colors.base16.base0F;
    };
  };
  programs.home-manager.enable = true;
  home = {
    username = "juanma";
    homeDirectory = "/home/juanma";
    stateVersion = "23.11";
  };
  # systemd services

  systemd.user.services."battery-notifier" = {
    Unit = { Description = "Systemd user service template"; };
    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "battery-notifier-script" ''
        set -eou pipefail
        ${pkgs.bash}/bin/bash "/home/juanma/.local/bin/batteryIndicator";
      '');
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers."battery-notifier" = {
    Unit = { Description = "sysdtimer template"; };
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "battery-notifier";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
