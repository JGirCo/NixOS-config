{
  inputs,
  pkgs,
  theme,
  lib,
  config,
  font,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit config lib colors;
  };
  bg = themeLib.semantic.bg;
  transparencyDefault = "${bg}E5";
  transparencyTest = "${bg}C0";
in
{
  # FIXME: Temporary workaround - Zen Browser still defaults to ~/.zen instead of ~/.config/zen
  # even though version 1.19t should use XDG dirs. Remove this once upstream fixes the issue.
  # See: https://github.com/0xc000022070/zen-browser-flake#missing-configuration-after-update
  home.activation.zenProfileSymlink = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e "$HOME/.zen" ] && [ ! -L "$HOME/.zen" ]; then
      mv "$HOME/.zen" "$HOME/.zen.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    if [ ! -L "$HOME/.zen" ]; then
      ln -sf "$HOME/.config/zen" "$HOME/.zen"
    fi
  '';

  programs.zen-browser.enable = true;
  programs.zen-browser.nativeMessagingHosts = [ pkgs.tridactyl-native ];
  programs.zen-browser.profiles."default" = {
    name = "default";
    id = 0;
    preConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "${transparencyDefault}");
    '';
    isDefault = true;
    settings = {
      # "browser.display.use_document_fonts" = 0;
      "font.default.x-western" = "sans-serif";
      "font.name.sans-serif.x-western" = font.sans;
      "font.name.serif.x-western" = font.serif;
      "font.name.monospace.x-western" = font.name;
    };
  };

  programs.zen-browser.profiles."Whatsapp" = {
    name = "Whatsapp";
    id = 1;
    preConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "${transparencyDefault}");
    '';
    isDefault = false;
  };

  programs.zen-browser.profiles."test" = {
    name = "test";
    id = 2;
    preConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "${transparencyTest}");
    '';
    isDefault = false;
  };
}
