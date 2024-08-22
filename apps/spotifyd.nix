{ config, lib, pkgs, ... }:

{
  services.spotifyd.enable = true;
  services.spotifyd.settings = {
    global = {
      username = "foo";
      password = "bar";
      device_name = "nix";
    };
  };
}
