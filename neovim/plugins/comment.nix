{
  programs.nixvim.plugins.comment = {
    enable = true;

    settings = {
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
  };
}
