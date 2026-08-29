{ config, pkgs, ... }:
{
  # Timers
  imports = [ ./timers/batteryNotifier.nix ];
}
