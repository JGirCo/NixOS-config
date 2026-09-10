# Boot configuration: bootloader, kernel parameters, resume device, initrd.
{
  config,
  ...
}:
{
  boot.initrd.kernelModules = [
    "nvme"
    "amdgpu"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/4b3336c0-2ee7-47ee-9ae8-4842776879e4";

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  boot.initrd.systemd.enable = true;

  # Bootloader setup using GRUB
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 5;
    minegrub-world-sel = {
      enable = true;
      customIcons = [
        {
          name = "nixos";
          lineTop = with config.system.nixos; distroName + " " + codeName + " (" + version + ")";
          lineBottom = "Survival Mode, No Cheats, Version: " + config.system.nixos.release;
          imgName = "nixos";
        }
      ];
    };
  };

  boot.plymouth = {
    enable = true;
    plymouth-minecraft-theme.enable = true;
  };

  boot.loader.timeout = -1; # No countdown timer — appreciate the theme

  # Console logging limits to prevent TTY corruption before greetd launches
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
