# Networking: systemd-networkd + iwd + systemd-resolved, hostname, firewall.
{ lib, ... }:
{
  networking = {
    hostName = "nixos";
    wireless.enable = false;
    networkmanager.enable = false;
    dhcpcd.enable = false;
    useNetworkd = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 37711 ]; # Allow the specific Minecraft LAN port
      allowedUDPPorts = [ 37711 ]; # Allow the specific Minecraft LAN port
    };
  };

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
}
