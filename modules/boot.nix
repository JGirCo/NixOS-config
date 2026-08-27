# Boot configuration: bootloader, kernel parameters, resume device, initrd.
{ pkgs, ... }:
let
  grubTheme = import ../derivations/grub-graphite-theme.nix { inherit pkgs; };
in
{
  boot.initrd.kernelModules = [
    "nvme"
    "amdgpu"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/4b3336c0-2ee7-47ee-9ae8-4842776879e4";
  boot.kernelParams = [
    "resume=UUID=4b3336c0-2ee7-47ee-9ae8-4842776879e4"
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "quiet"
    "splash"
  ];

  boot.initrd.systemd.enable = true;

  # Bootloader setup using GRUB
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 10; # Keep the boot menu clean by limiting stored generations
    theme = grubTheme;
  };

  # Boot splash screen
  boot.plymouth = {
    enable = true;
  };

  boot.loader.timeout = -1; # No countdown timer — appreciate the theme

  # Console logging limits to prevent TTY corruption before greetd launches
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
