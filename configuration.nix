# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

flake-overlays:

{ config, pkgs, font, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable bluetooth

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  hardware.graphics.enable = true;

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

  # Enable the X11 windowing system.
  security.polkit.enable = true;
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver.displayManager.lightdm.enable = true;

  # Enable i3wm
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  # };
  programs.sway.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.logind = {
    # don’t shutdown when power button is short-pressed
    lidSwitch = "suspend";
    powerKey = "suspend";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jgirco = {
    isNormalUser = true;
    description = "Juan Manuel Giraldo";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic tools
    git
    wget
    gcc
    gnumake
    ripgrep
    python3
    cargo
    rustc
    rust-analyzer
    arduino-language-server
    zip
    unzip
    gh
    fd
    coreutils
    clang
    busybox
    luajit
    wine
    pandoc

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qtstyleplugins

    #System tools
    xclip
    acpi
    pamixer
    playerctl

    # Terminal Tools
    kitty
    wezterm
    libqalculate
    translate-shell
    plantuml

    # TUI Tools
    cava
    emacs
    yazi-unwrapped
    lazygit
    bottom
    bluetuith
    spotify-player
    zsh-powerlevel10k
    pulsemixer
    ncdu

    # GUI Tools
    ripdrag
    nsxiv
    spot
    zotero
    vipsdisp
    itch
    thunderbird
    libreoffice
    pcmanfm
    inkscape
    bottles
    lutris
    ungoogled-chromium
    vlc
    projectm
    matlab
    floorp

    # Miscelaneous
    firefoxpwa

    #python
    python311Packages.pyserial
  ];

  nixpkgs.overlays = flake-overlays;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "pcmanfm.desktop";
    "image/png" = "nsxiv.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {

    neovim = {
      enable = true;
      defaultEditor = true;
    };
    zsh.enable = true;
    light.enable = true;
    kdeconnect.enable = true;
    dconf.enable = true;
    firefox = {
      enable = true;
      # package = pkgs.firefox-beta-bin;
      nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Systemd timers

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
