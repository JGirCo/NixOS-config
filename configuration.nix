# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

flake-overlays:

{
  inputs,
  config,
  pkgs,
  lib,
  browser,
  font,
  ...
}:

with pkgs;
let
  maplefont = import ./derivations/maple-font.nix { inherit pkgs; };
  legion-kb-rgb = inputs.legion-kb-rgb.packages.${pkgs.stdenv.hostPlatform.system}.default;

  patchDesktop =
    pkg: from: to:
    lib.hiPrio (
      pkgs.runCommand "offload-${pkg.name}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        for file in ${pkg}/share/applications/*.desktop; do
          base=$(${coreutils}/bin/basename "$file")
          ${gnused}/bin/sed 's#${from}#${to}#g' "$file" > $out/share/applications/$base
        done
      ''
    );

  GPUOffloadApp = pkg: patchDesktop pkg "^Exec=" "Exec=nvidia-offload ";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  services.hardware.bolt.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 37711 ]; # Allow the specific Minecraft LAN port
    allowedUDPPorts = [ 37711 ]; # Allow the specific Minecraft LAN port
  };
  programs.weylus = {
    enable = true;
    openFirewall = true;
  };

  powerManagement.enable = true;
  virtualisation.docker.enable = true;
  boot.initrd.kernelModules = [ "nvme" ];
  boot.resumeDevice = "/dev/disk/by-uuid/4b3336c0-2ee7-47ee-9ae8-4842776879e4";
  boot.kernelParams = [ "resume=UUID=4b3336c0-2ee7-47ee-9ae8-4842776879e4" ];
  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics.enable = true;
    graphics.enable32Bit = true;
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    amdgpu.initrd.enable = false;
    nvidia = {

      # Modesetting is required.
      modesetting.enable = true;
      powerManagement.finegrained = true;
      dynamicBoost.enable = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  boot.kernelModules = [
    "lenovo-legion-module"
    "amdgpu"
    "k10temp"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];
  boot.extraModprobeConfig = "options snd_hda_intel power_save=0";

  services.udev.extraRules = ''SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c994", MODE="0666"'';

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "jgirco"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.wireless.enable = false;
  networking.networkmanager.enable = false;
  networking.dhcpcd.enable = false;
  networking.useNetworkd = true;

  systemd.network.networks."10-wired" = {
    matchConfig.Name = "en* eth*";
    networkConfig = {
      DHCP = "yes";
    };
    dhcpV4Config.RouteMetric = lib.mkForce 100;
    ipv6AcceptRAConfig.RouteMetric = lib.mkForce 100;
  };

  systemd.network.networks."20-wireless" = {
    matchConfig.Name = "wl*";
    networkConfig = {
      DHCP = "yes";
      IgnoreCarrierLoss = "3s";
    };
    dhcpV4Config.RouteMetric = 600;
    ipv6AcceptRAConfig.RouteMetric = 600;
  };

  # Enable iwd
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    IPv6 = {
      Enabled = true;
    };
    Network = {
      EnableNetworkConfiguration = false;
    };
    Settings = {
      AutoConnect = true;
    };
  };
  services.resolved.enable = true;

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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %A, %B %d' --issue --asterisks --greet-align left --remember --remember-session --cmd 'uwsm start niri-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # Optional but recommended: suppress kernel logging to the console
  # so your TTY greeter doesn't get visually corrupted by boot messages.
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

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
            "f23+leftmeta+leftshift" = "layer(nav)";
          };
          # "shift+alt" = {
          #   "h" = "left";
          #   "k" = "up";
          #   "j" = "down";
          #   "l" = "right";
          # };
          "nav" = {
            "h" = "left";
            "k" = "up";
            "j" = "down";
            "l" = "right";
          };
        };
      };
    };
  };

  users.groups.keyd = {
    members = [
      "root"
      "jgirco"
    ];
  };
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
    wireplumber.enable = true;
  };

  services.logind.settings.Login = {
    # never suspend when the lid is closed
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    # hibernate when the power button is short-pressed
    HandlePowerKey = "hibernate";
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.gtklock}/bin/gtklock";
  };

  security.pam.services = {
    gtklock = { };
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowSuspendThenHibernate = "yes";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jgirco = {
    isNormalUser = true;
    description = "Juan Manuel Giraldo";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "input"
      "keyd"
      "sensors"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  services.flatpak = {
    enable = true;
    packages = [
      "de.z_ray.OptimusUI"
      "io.github.qwersyk.Newelle"
    ];
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
    lm_sensors
    (texlive.combine { inherit (texlive) scheme-medium standalone; })

    #System tools
    keyd
    acpi
    pamixer
    playerctl
    udiskie
    ffmpeg

    #Network tools
    mosquitto

    # Terminal Tools
    libqalculate
    translate-shell
    plantuml
    openpomodoro-cli
    gemini-cli-bin
    opencode
    claude-code

    # TUI Tools
    ncdu
    ytermusic
    ouch-rar

    # GUI Tools
    rpi-imager
    kicad
    python313Packages.python-lsp-server
    python313Packages.python-lsp-black
    blockbench
    pavucontrol
    ripdrag
    zotero
    vipsdisp
    libreoffice
    nautilus
    inkscape
    ungoogled-chromium
    # floorp
    # deluge
    qbittorrent

    # Miscelaneous
    mpris-scrobbler
    tridactyl-native
    nix-prefetch-github
    lenovo-legion
    # legion-kb-rgb
    gtklock

    #games
    gamescope
    _2048-in-terminal
    prismlauncher

    (GPUOffloadApp steam)
    (GPUOffloadApp prismlauncher)
  ];
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-cuda;
  # };

  nixpkgs.overlays = flake-overlays;

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

  fonts.fontDir.enable = true;
  fonts.packages =
    if font.isNF then
      with pkgs; [ nerdfonts ]
    else
      [
        maplefont
        pkgs.atkinson-hyperlegible-next
        pkgs.lexend
        pkgs.ibm-plex
      ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
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

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 2";
      clean.dates = "monthly";
      flake = "/home/jgirco/.nixos/";
    };
  };

  users.groups.libvirtd.members = [ "jgirco" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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
