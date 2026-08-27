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

  # ---- Gaming-Console shared logic ----
  # Single source of truth: ROM dir -> libretro core. Everything else
  # (extensions, core store paths, ES-DE shortnames) is derived from this.
  retroSystems = [
    {
      dir = "SNES";
      core = "snes9x";
      romsDir = "snes";
    }
    {
      dir = "GBA";
      core = "mgba";
      romsDir = "gba";
    }
    {
      dir = "PS1";
      core = "swanstation";
      romsDir = "psx";
    }
    {
      dir = "PSP";
      core = "ppsspp";
      romsDir = "psp";
    }
    {
      dir = "Gamecube";
      core = "dolphin";
      romsDir = "gc";
    }
  ];

  actkbdBindings = [
    {
      keys = [ 224 ];
      events = [ "key" ];
      command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
    }
    {
      keys = [ 225 ];
      events = [ "key" ];
      command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
    }
    {
      keys = [ 113 ];
      events = [ "key" ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
    }
    {
      keys = [ 114 ];
      events = [
        "key"
        "rep"
      ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
    }
    {
      keys = [ 115 ];
      events = [
        "key"
        "rep"
      ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'";
    }
  ];

  mkGamescopeConsoleSpecialisation =
    {
      name,
      spawn,
      extraPackages ? [ ],
    }:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      sessionScript = pkgs.writeShellScript "gamescope-console-${name}-session" ''
        # Mask desktop services that would fight the console session.
        for svc in waybar awww-daemon iwgtk apply-theme; do
          ${pkgs.systemd}/bin/systemctl --user mask --runtime "$svc.service" 2>/dev/null || true
        done

        # NVIDIA VK_KHR_present_wait freeze workaround. Gamescope's WSI layer
        # force-enables this with overwrite=0, so pre-setting it false disables
        # the extension for games launched through gamescope.
        export vk_khr_present_wait=false
        # Enable the gamescope WSI layer for Vulkan apps launched through us.
        export ENABLE_GAMESCOPE_WSI=1

        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=gamescope

        ${pkgs.systemd}/bin/systemctl --user start pipewire.service wireplumber.service || true
        ${pkgs.systemd}/bin/systemctl --user import-environment \
          WAYLAND_DISPLAY DISPLAY XDG_RUNTIME_DIR \
          XDG_SESSION_TYPE XDG_CURRENT_DESKTOP \
          PULSE_RUNTIME_PATH PULSE_SERVER || true
        ${pkgs.systemd}/bin/systemctl --user start graphical-session.target || true
        ${pkgs.systemd}/bin/systemctl --user start sunshine.service || true

        exec ${spawn}
      '';
    in
    {
      environment.systemPackages = extraPackages;

      programs.gamescope = {
        enable = true;
        enableWsi = true;
      };

      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };

      services.sunshine = {
        enable = true;
        autoStart = lib.mkForce true;
        capSysAdmin = lib.mkForce true; # KMS capture under gamescope
      };

      services.actkbd = {
        enable = true;
        bindings = actkbdBindings;
      };

      services.greetd.settings.default_session = {
        user = "jgirco";
        command = lib.mkForce "${pkgs.gamescope}/bin/gamescope -f --xwayland-count 1 -w 2560 -h 1600 -W 2560 -H 1600 --force-grab-cursor -- ${sessionScript}";
      };

      services.logind.settings.Login = {
        HandlePowerKey = lib.mkForce "poweroff";
      };
    };

  # --- ES-DE (AppImage) ---
  esde = pkgs.appimageTools.wrapType2 {
    pname = "es-de";
    version = "3.4.1";
    src = pkgs.fetchurl {
      url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
      hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
    };
  };

  esdeConsole = pkgs.writeShellScriptBin "esde-console" ''
        set -euo pipefail
        ROMROOT="$HOME/Games/ROMS"
        ESDEROMS="$HOME/ROMs"
        CORESDIR="$HOME/.config/retroarch/cores"
        STEAMDIR="$HOME/.local/share/Steam/steamapps"
        mkdir -p "$CORESDIR" "$ESDEROMS" "$ESDEROMS/steam" "$HOME/.local/bin" "$HOME/.config/retroarch"

        # Symlink installed cores so ES-DE's %CORE_RETROARCH% find-rule can use them.
        ${lib.concatMapStringsSep "\n" (
          s:
          "ln -sf ${pkgs.libretro.${s.core}}/lib/retroarch/cores/${s.core}_libretro.so \"$CORESDIR/${s.core}_libretro.so\""
        ) retroSystems}

        # Symlink ROMs into ES-DE's standard ~/ROMs structure.
        ${lib.concatMapStringsSep "\n" (
          s:
          "if [ -d \"$ROMROOT/${s.dir}\" ]; then ln -sfn \"$ROMROOT/${s.dir}\" \"$ESDEROMS/${s.romsDir}\"; fi"
        ) retroSystems}

        # RetroArch's own exclusive fullscreen is broken under niri (black screen).
        # Instead run it as a borderless windowed fullscreen and let niri's
        # window-rule (excluded from forced fullscreen) present it natively.
        cat > "$HOME/.config/retroarch/niri-console.cfg" <<'CFG'
    video_fullscreen = "true"
    video_windowed_fullscreen = "true"
    CFG
        # The binary ES-DE finds (via PATH) as %EMULATOR_RETROARCH%: a wrapper that
        # injects the windowed override for every RetroArch launch. Remove any prior
        # symlink first (a symlink to the read-only store would make the write fail).
        rm -f "$HOME/.local/bin/retroarch"
        cat > "$HOME/.local/bin/retroarch" <<EOF
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.retroarch}/bin/retroarch --appendconfig="\$HOME/.config/retroarch/niri-console.cfg" "\$@"
    EOF
        chmod +x "$HOME/.local/bin/retroarch"

        # Populate the ES-DE "steam" system from Steam appmanifests.
        if [ -d "$STEAMDIR" ]; then
          for mf in "$STEAMDIR"/appmanifest_*.acf; do
            [ -e "$mf" ] || continue
            appid=$(sed -n 's/.*"appid"[[:space:]]*"\([0-9]*\)".*/\1/p' "$mf" | head -1)
            name=$(sed -n 's/.*"name"[[:space:]]*"\(.*\)".*/\1/p' "$mf" | head -1)
            [ -n "$appid" ] && [ -n "$name" ] || continue
            cat > "$ESDEROMS/steam/$name.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=$name
    Exec=env STEAM_FRAME_FORCE_CLOSE=1 ${pkgs.steam}/bin/steam -applaunch $appid
    EOF
          done
        fi

        # Pre-warm Steam so its window doesn't pop up on first game launch.
        # STEAM_FRAME_FORCE_CLOSE prevents Steam from taking focus when a game
        # exits/launches from another frontend.
        STEAM_FRAME_FORCE_CLOSE=1 ${pkgs.steam}/bin/steam -silent &

        exec ${esde}/bin/es-de
  '';
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
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Systemd socket will spin up daemon on first docker command
  };
  boot.initrd.kernelModules = [ "nvme" ];
  boot.resumeDevice = "/dev/disk/by-uuid/4b3336c0-2ee7-47ee-9ae8-4842776879e4";
  boot.kernelParams = [
    "resume=UUID=4b3336c0-2ee7-47ee-9ae8-4842776879e4"
    "nvidia-drm.modeset=1"
  ];

  # "video=HDMI-A-1:1280x960@60e"
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
    "lenovo-legion"
    "amdgpu"
    "nvme"
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
  systemd.network.wait-online.enable = false;

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
    HandlePowerKey = lib.mkDefault "hibernate";
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
      "input"
      "uinput"
      "render"
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "input"
      "keyd"
      "sensors"
      "audio"
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
    wlr-randr

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
    opencode
    claude-code
    ncdu
    ytermusic
    ouch-rar
    steamcmd

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
    ungoogled-chromium
    # floorp
    # deluge
    qbittorrent
    steam-rom-manager

    # Miscelaneous
    mpris-scrobbler
    tridactyl-native
    nix-prefetch-github
    lenovo-legion
    # legion-kb-rgb
    gtklock

    #games
    prismlauncher

    (GPUOffloadApp prismlauncher)
  ];
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-cuda;
  # };

  environment.pathsToLink = [ "/lib" ];

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

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 2";
      clean.dates = "monthly";
      flake = "/home/jgirco/.nixos/";
    };
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
    };
  };

  specialisation = {
    "Gaming-Console".configuration = mkGamescopeConsoleSpecialisation {
      name = "esde";
      spawn = "${esdeConsole}/bin/esde-console";
      extraPackages = [
        esde
        pkgs.kitty
        pkgs.gamescope
        pkgs._2048-in-terminal
        (pkgs.retroarch.withCores (
          cores: with cores; [
            snes9x
            mgba
            ppsspp
            swanstation
            dolphin
          ]
        ))
        (GPUOffloadApp pkgs.steam)
      ];
    };
  };
  users.groups.libvirtd.members = [ "jgirco" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = false; # Required for Wayland KMS screen capture
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };
  systemd.user.services.sunshine = {
    path = with pkgs; [
      wlr-randr
      steam
      bash
    ];
  };

  hardware.uinput.enable = true;

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
