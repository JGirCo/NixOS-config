{
  pkgs,
  theme,
  font,
  ...
}:

let
  themeScheme = import ../lib/scheme.nix {
    inherit pkgs;
    themes = import ../themes.nix;
  } theme;
in
{
  stylix = {
    enable = true;
    inherit (themeScheme) polarity base16Scheme override;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
      sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
    };

    fonts = {
      monospace = font.mono;
      sansSerif = font.sans;
      serif = font.serif;
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.qogir-icon-theme;
      dark = "Qogir";
      light = "Qogir";
    };

    targets.zen-browser.profileNames = [
      "default"
      "Whatsapp"
    ];

    targets.waybar.enable = false;
    targets.qt.enable = true;
    targets.kitty.enable = true;
    targets.zathura.enable = false;
    targets.mako.enable = true;
    targets.nixvim.enable = true;
    targets.vesktop.enable = true;
    targets.nixcord.enable = true;
    # targets.zen-browser.enable = false;
  };
}
