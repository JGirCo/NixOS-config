{ inputs, pkgs, ... }: {
  imports = [
    # inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser.nativeMessagingHosts =
    [ pkgs.firefoxpwa pkgs.tridactyl-native ];
  profiles."default" = {
    name = "default";
    extraConfig = ''
      user_pref("mod.sameerasw.zen_transparency_color", "#");
    ''
  };
}
