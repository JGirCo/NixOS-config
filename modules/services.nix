# Background services / daemons: docker, pipewire (audio), libvirtd (KVM/QEMU),
# and sunshine (game streaming).
{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Systemd socket will spin up daemon on first docker command
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
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
}
