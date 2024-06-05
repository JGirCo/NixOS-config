{ config, pkgs, ... }: {
  # Timers
  imports = [ ./timers/batteryNotifier.nix ];
  # home.packages = [ (import ./batteryNotifier.nix { inherit pkgs; }) ];
}
