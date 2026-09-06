{
  ...
}:
{
  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    # discord.vencord.enable = true;
    discord.enable = false;
    # vencord.enable = true;

    config = {
      useQuickCss = true;
      frameless = true;
    };
  };
}
