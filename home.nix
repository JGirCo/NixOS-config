{
  pkgs,
  inputs,
  theme,
  font,
  lib,
  ...
}:

let
  themes = import ./themes.nix;
  themeColors = themes.${theme} or themes."catppuccin-macchiato";
in
{
  imports = [

    ./home-services.nix
    ./zsh.nix
    ./desktop/stylix.nix
    ./desktop/walker.nix
    ./desktop/niri.nix
    ./desktop/niri-animations.nix

    ./apps/terminal.nix
    ./apps/zen.nix
    ./apps/nixcord.nix

    ./neovim/default.nix

    ./apps/zathura.nix
    ./apps/tmux.nix
    ./apps/cava.nix
    ./apps/directwrite/keyd-application-mapper.nix
    ./apps/directwrite/tridactyl.nix

    ./scripts/default.nix
  ];

  _module.args.colors = themeColors;

  programs.home-manager.enable = true;
  home = {
    username = "jgirco";
    homeDirectory = "/home/jgirco";
    stateVersion = "23.11";

    sessionVariables = {
      THEME = theme;
      THEME_POLARITY = themeColors.polarity;
    };
  };

  # Mako notification daemon. Stylix themes the default config via
  # targets.mako; we override font + add rounded corners on top.
  services.mako.enable = true;
  services.mako.settings = {
    font = lib.mkForce "${font.sans.name} 20";
    border-radius = 16;
  };

  # The mako package ships a D-Bus-activated systemd unit, but home-manager
  # neither installs nor enables it. Declare it here so D-Bus can activate it
  # and it starts with the graphical session (no imperative systemctl needed).
  systemd.user.services.mako = {
    Unit = {
      Description = "Lightweight Wayland notification daemon";
      Documentation = [ "man:mako(1)" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecCondition = "/bin/sh -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
      ExecStart = "${pkgs.mako}/bin/mako";
      ExecReload = "${pkgs.mako}/bin/makoctl reload";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  nixpkgs.config.allowUnfree = true;
  home.file = {
    ".local/share/applications/org.libvips.vipsdisp.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Version=1.4
      Name=Vipsdisp
      GenericName=Image Viewer
      Comment=View large scientific images
      Icon=org.libvips.vipsdisp
      Keywords=vipsdisp;graphic;view;image;
      Categories=Graphics;2DGraphics;RasterGraphics;
      StartupNotify=true
      Exec=vipsdisp %U
      MimeType=image/gif;image/x-fits;image/x-pcx;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/tiff;image/jpeg;image/png;image/x-exr;image/webp;image/x-webp;image/heif;image/heic;image/svg+xml;application/pdf;image/jp2;image/jxl;image/mrxs;image/svs;image/ndpi;image/avf;text/x-matlab;text/csv;
    '';
  };

  home.packages = with pkgs; [
    libnotify # for notify-send

    #GUI
    freecad-wayland
    mangohud
    celluloid
    gparted
    yt-dlp
    parabolic
    vipsdisp
    bottles
    lutris
    vlc

    #TUI
    bitwarden-cli
    cava
    yazi-unwrapped
    wiremix
    lazygit
    bottom
    bluetui
    pulsemixer
    skyscraper
    inputs.wl_shimeji.packages.${stdenv.hostPlatform.system}.default
    just
    gum
    file
  ];
}
