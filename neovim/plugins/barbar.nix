{
  programs.nixvim.plugins.barbar = {
    enable = true;
    keymaps = {
      next.key = "<M-l>";
      previous.key = "<M-h>";
      close.key = "<M-w>";
    };
  };
}
