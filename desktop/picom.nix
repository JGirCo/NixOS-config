{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    shadow = false;
    fade = true;
    fadeSteps = [ 4.0e-2 4.0e-2 ];
    inactiveOpacity = 0.95;
    opacityRules = [
      # "85:class_g = 'org.wezfurlong.wezterm'"
      "85:class_g = 'emacs'"
      "85:class_g = 'Emacs'"
      "85:class_g = 'i3bar'"
    ];
    vSync = true;
  };
}
