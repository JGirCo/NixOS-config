# Input devices: X11 keymap, keyd (kbd remap daemon), libinput (touchpad),
# console keymap.
{ ... }:
{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            "f23+leftmeta+leftshift" = "layer(nav)";
          };
          # "shift+alt" = {
          #   "h" = "left";
          #   "k" = "up";
          #   "j" = "down";
          #   "l" = "right";
          # };
          "nav" = {
            "h" = "left";
            "k" = "up";
            "j" = "down";
            "l" = "right";
          };
        };
      };
    };
  };

  users.groups.keyd = {
    members = [
      "root"
      "jgirco"
    ];
  };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";
}
