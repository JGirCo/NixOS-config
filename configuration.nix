# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

flake-overlays:

{ inputs, config, pkgs, font, ... }:

let maplefont = import ./derivations/maple-font.nix { inherit pkgs; };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot =
      true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
    nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  programs.hyprland = { enable = true; };

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

  services.blueman.enable = true;

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
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.debug = true;

  # Enable i3wm
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  # };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            "rightshift" = "up";
            "up" = "down";
          };
          "shift+alt" = {
            "h" = "left";
            "k" = "up";
            "j" = "down";
            "l" = "right";
          };
        };
      };
    };
  };
  users.groups.keyd = { members = [ "root" ]; };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    lidSwitch = "suspend-then-hibernate";
    powerKey = "hibernate";
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jgirco = {
    isNormalUser = true;
    description = "Juan Manuel Giraldo";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  services.flatpak = {
    enable = true;
    packages = [ "io.github.qwersyk.Newelle" ];
  };
  environment.systemPackages = with pkgs; [
    # Basic tools
    git
    wget
    gcc
    rsync
    gnumake
    ripgrep
    zip
    unzip
    gh
    fd
    coreutils
    luajit
    wine
    exfatprogs

    devenv

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qtstyleplugins

    #System tools
    keyd
    acpi
    pamixer
    playerctl
    udiskie

    # Terminal Tools
    kitty
    wezterm
    libqalculate
    translate-shell
    plantuml

    # TUI Tools
    pavucontrol
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
    foot
    airshipper
    freecad-wayland
    celluloid
    gparted
    pavucontrol
    ripdrag
    zotero
    vipsdisp
    libreoffice
    pcmanfm
    inkscape
    bottles
    lutris
    ungoogled-chromium
    floorp
    deluge
    inputs.zen-browser.packages."${system}".specific

    # Miscelaneous

    #python
    python311Packages.pyserial
  ];

  nixpkgs.overlays = flake-overlays;

  environment.sessionVariables = rec {
    QT_STYLE_OVERRIDE = "kvantum";
    GSK_RENDERER = "gl";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    GBM_BACKEND = ''
      nvidia-drm
      __GLX_VENDOR_LIBRARY_NAME=nvidia'';

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "pcmanfm.desktop";
    "image/png" = "vipsdisp.desktop";
    "x-scheme-handler/http" = "floorp.desktop";
    "x-scheme-handler/https" = "floorp.desktop";
    "x-scheme-handler/about" = "floorp.desktop";
    "x-scheme-handler/unknown" = "floorp.desktop";
  };

  fonts.fontDir.enable = true;
  fonts.packages = if font.isNF then
  # with pkgs; [ (nerdfonts.override { fonts = [ font.nameNF ]; }) ]
    with pkgs; [ nerdfonts ]
  else
  # with pkgs; [ maple-mono miracode monaspace ];
    [ maplefont ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {

    neovim = {
      enable = true;
      defaultEditor = true;
    };
    zsh.enable = true;
    light.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
    dconf.enable = true;
    firefox = {
      enable = true;
      package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
      nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/jgirco/.nixos/";
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
