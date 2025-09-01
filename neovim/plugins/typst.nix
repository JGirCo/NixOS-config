{
  programs.nixvim = {
    plugins.typst-vim = {
      enable = true;
      keymaps.watch = "<leader>P";
    };

    files."after/ftplugin/typst.lua" = {
      localOpts.conceallevel = 1;
      opts = {
        wrap = true;
        breakindent = true;
        linebreak = true;
      };
    };
  };
}
