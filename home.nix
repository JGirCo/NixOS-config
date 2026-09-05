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
  themes = import ./themes.nix;
  themeColors = themes.${theme} or themes."catppuccin-macchiato";
  colors = themeColors // {
    nvimEngine = themeColors.nvimEngine or "builtin";
    isBase16Builtin = themeColors.isBase16Builtin or true;
  };
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

    ./neovim/default.nix

    ./apps/zathura.nix
    ./apps/tmux.nix
    ./apps/cava.nix
    ./apps/directwrite/keyd-application-mapper.nix
    ./apps/directwrite/tridactyl.nix

    ./scripts/default.nix

    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  _module.args.colors = colors;

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

  # Mako notification daemon (replaces swaync). Stylix themes the
  # default config via targets.mako; we override font + add rounded
  # corners on top.
  services.mako.enable = true;
  services.mako.settings = {
    font = lib.mkForce "Atkinson Hyperlegible Next 20";
    border-radius = 16;
  };

  # Mako is D-Bus activated by default, but the D-Bus service file uses
  # SystemdService=mako.service, so we need to enable the user service
  # for D-Bus to be able to start it.
  home.activation.makoSystemdService = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    systemctl --user enable --now mako.service 2>/dev/null || true
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
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
    mako # notification daemon (replaces swaync)

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
