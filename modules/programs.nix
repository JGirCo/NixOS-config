# User programs (NixOS `programs.*`): direnv, neovim, zsh, kdeconnect, dconf,
# nh, gamemode, weylus, plus the flatpak service.
{ ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "de.z_ray.OptimusUI"
      "io.github.qwersyk.Newelle"
    ];
  };

  programs = {
    direnv = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    zsh.enable = true;
    kdeconnect = {
      enable = true;
    };
    dconf.enable = true;
    # firefox = {
    #   enable = true;
    #   package =
    #     inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
    #   nativeMessagingHosts.packages = [ pkgs.firefoxpwa pkgs.tridactyl-native ];
    # };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 2";
      clean.dates = "monthly";
      flake = "/home/jgirco/.nixos/";
    };

    weylus = {
      enable = true;
      openFirewall = true;
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
      };
    };
  };
}
