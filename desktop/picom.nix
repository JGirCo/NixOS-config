{ config, lib, pkgs, ... }:


{
    services.picom = {
      enable = true;
      shadow = false;
      fade = true;
      fadeSteps = [ 0.04 0.04 ];
      inactiveOpacity = .95;
      opacityRules = [
        "85:class_g = 'org.wezfurlong.wezterm'"
        "85:class_g = 'emacs'"
        "85:class_g = 'Emacs'"
        "85:class_g = 'i3bar'"
      ];
      vSync = true;
    };
}
