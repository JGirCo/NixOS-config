# Desktop: X11 server, display manager (greetd + tuigreet), compositor (niri+uwsm),
# Cinnamon fallback DE, polkit, autorandr, system-level stylix theming, xdg mime
# associations and fontconfig.
{ pkgs, browser, ... }:
{
  # Enable the X11 windowing system.
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.autorandr.enable = true;

  services.xserver.desktopManager.cinnamon.enable = true;
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  programs.uwsm = {
    enable = true;
    waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "Niri compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/niri";
      extraArgs = [ "--session" ];
    };
  };

  # Permanent system-level theming (dracula).
  # Home-manager Stylix handles per-theme user app theming; this one themes
  # system-level pieces (console TTY colors for the greeter, fontconfig, gtk,
  # qt fallbacks) and stays fixed regardless of the home-manager theme.
  stylix = {
    enable = true;
    polarity = "dark";
    image = "/home/jgirco/Pictures/wallpapers/dracula.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    fonts = {
      monospace = {
        name = "Maple Mono NF";
        package = pkgs.maple-mono.NF;
      };
      sansSerif = {
        name = "Lexend deca";
        package = pkgs.lexend;
      };
      serif = {
        name = "IBM Plex Serif";
        package = pkgs.ibm-plex;
      };
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %A, %B %d' --issue --asterisks --greet-align left --remember --remember-session --cmd 'uwsm start niri-uwsm.desktop'";
        user = "jgirco";
      };
    };
  };

  # This is required so tuigreet can find the sessions
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Better for debugging!
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "nautilus.desktop";
    "image/png" = "vipsdisp.desktop";
    "x-scheme-handler/http" = "${browser.name}.desktop";
    "x-scheme-handler/https" = "${browser.name}.desktop";
    "x-scheme-handler/about" = "${browser.name}.desktop";
    "x-scheme-handler/unknown" = "${browser.name}.desktop";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
