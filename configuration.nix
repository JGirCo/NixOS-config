# Top-level NixOS configuration. The flake (`flake.nix`) calls
# `(import ./configuration.nix flake-overlays)` and then passes the result
# to `lib.nixosSystem` along with `specialArgs = { browser, font, inputs }`.
#
# This file now just imports the modularized pieces under `./modules/` and
# applies the flake-level overlays.
flake-overlays:

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./gaming-console.nix

    # Modularized configuration.
    ./modules/hardware.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/desktop.nix
    ./modules/input.nix
    ./modules/packages.nix
    ./modules/environment.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/user.nix
  ];

  # Flake-provided overlays (e.g. niri).
  nixpkgs.overlays = flake-overlays;
}
