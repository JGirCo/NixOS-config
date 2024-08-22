{
  programs.nixvim = {
    plugins.hop.enable = true;
    keymaps = [
    {
      mode = ["n"];
      key = "s";
      action = ":HopVertical<CR>";
    }
    {
      mode = ["n"];
      key = "S";
      action = ":HopChar2CurrentLine<CR>";
    }
    ];
  };
}
