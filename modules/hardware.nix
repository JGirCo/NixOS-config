# Hardware-related configuration: CPU, GPU (NVIDIA prime offload + AMD),
# bluetooth, kernel modules, udev rules, printing, etc.
{ config, lib, ... }:
{
  services.hardware.bolt.enable = true;

  powerManagement.enable = true;

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

  # Enable bluetooth (blueman tray)
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.uinput.enable = true;
}
