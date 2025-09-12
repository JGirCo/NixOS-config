{
  programs.nixvim = {
    plugins.hop.enable = true;
    keymaps = [
      {
        mode = [ "n" ];
        key = ";";
        action = ":HopVertical<CR>";
      }
      {
        mode = [ "n" ];
        key = ",";
        action = ":HopChar2CurrentLine<CR>";
      }
    ];
  };
}
