{
  programs.nixvim.plugins.barbar = {
    enable = true;
    keymaps = {
      silent = true;

      next = "<leader><TAB>";
      previous = "<leader><S-TAB>";
      close = "<leader>q";
    };
  };
}
