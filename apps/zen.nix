{ inputs, pkgs, theme, lib, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in {
  imports = [
    # inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser.enable = true;
  programs.zen-browser.nativeMessagingHosts = [ pkgs.tridactyl-native ];
  programs.zen-browser.profiles."default" = {
    name = "default";
    preConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "#${colors.base}C0");
    '';
    isDefault = true;
  };

  programs.zen-browser.profiles."Whatsapp" = {
    name = "Whatsapp";
    id = 1;
    preConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "#${colors.base}C0");
    '';
    isDefault = false;
  };
  # programs.firefox.enable = true;
  # programs.firefox.profiles."test" = {
  #   name = "test";
  #   preConfig = ''
  #     user_pref("mod.sameerasw.zen_transparency_color", "#00f1ffC0");
  #   '';
  #   isDefault = true;
  #   search.default = "dgg";
  # };
}
