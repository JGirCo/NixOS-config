{
  pkgs,
  config,
  theme,
  ...
}:

let
  themes = import ../themes.nix;
  themeColors = themes.${theme} or themes."catppuccin-macchiato";
  scheme = themeColors.scheme;
  base16Scheme =
    if scheme ? file then "${pkgs.base16-schemes}/share/themes/${scheme.file}.yaml" else scheme.palette;
in
{
  stylix = {
    enable = true;
    polarity = themeColors.polarity or "dark";
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
      sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
    };

    inherit base16Scheme;

    override = scheme.override or { };

    fonts = {
      monospace = {
        name = "Maple Mono NF";
        package = pkgs.maple-mono.NF;
      };
      sansSerif = {
        name = "Atkinson Hyperlegible Next";
        package = pkgs.atkinson-hyperlegible-next;
      };
      serif = {
        name = "IBM Plex Serif";
        package = pkgs.ibm-plex;
      };
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
    targets.swaync.enable = false;
    targets.mako.enable = true;
    # targets.zen-browser.enable = false;
  };
}
