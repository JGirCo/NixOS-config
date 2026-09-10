# Environment-level configuration: Nix settings, nixpkgs options, locale,
# timezone, paths, session variables, MOTD banner, system stateVersion.
{ font, ... }:
{
  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "jgirco"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  environment.pathsToLink = [ "/lib" ];

  environment.sessionVariables = rec {
    GSK_RENDERER = "gl";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  environment.etc."issue".text = ''
    ███╗   ███╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗ ██████╗
    ████╗ ████║██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗
    ██╔████╔██║█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║
    ██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██║   ██║
    ██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ╚██████╔╝
    ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝

    ██╗   ██╗██╗██╗   ██╗███████╗██████╗ ███████╗
    ██║   ██║██║██║   ██║██╔════╝██╔══██╗██╔════╝
    ██║   ██║██║██║   ██║█████╗  ██████╔╝█████╗
    ╚██╗ ██╔╝██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══╝
     ╚████╔╝ ██║ ╚████╔╝ ███████╗██║  ██║███████╗
      ╚═══╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝
  '';

  environment.localBinInPath = true;

  fonts.fontDir.enable = true;
  fonts.packages = map (f: f.package) (builtins.attrValues font);

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
