{
  programs.nixvim.plugins.comment-nvim = {
    enable = true;

    opleader = {
      line = "gc";
      block = "gb";
    };
    toggler = {
      line = "gcc";
      block = "gbc";
    };
    # toggler = {line = "<C-b>";};
  };
}
