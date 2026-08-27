# Boot configuration: bootloader, kernel parameters, resume device, initrd.
{ ... }:
{
  boot.initrd.kernelModules = [ "nvme" ];
  boot.resumeDevice = "/dev/disk/by-uuid/4b3336c0-2ee7-47ee-9ae8-4842776879e4";
  boot.kernelParams = [
    "resume=UUID=4b3336c0-2ee7-47ee-9ae8-4842776879e4"
    "nvidia-drm.modeset=1"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optional but recommended: suppress kernel logging to the console
  # so your TTY greeter doesn't get visually corrupted by boot messages.
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
