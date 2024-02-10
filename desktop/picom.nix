{ config, lib, pkgs, ... }:

{
  home-manager.users.juanma = { pkgs, ... }: {
    services.picom = {
      enable = true;
      shadow = false;
      fade = true;
      fadeSteps = [ 0.04 0.04 ];
      inactiveOpacity = .95;
      opacityRules = [ "90:class_g = 'org.wezfurlong.wezterm'" ];
      vSync = true;
    };
  };
}
