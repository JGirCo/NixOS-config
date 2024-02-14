{
  programs.nixvim = {
    enable = true;
    vimAlias = true;

    # Configure neovim options...
    options = {
      relativenumber = true;
      incsearch = true;
    };

keymaps = [
  {
    # Default mode is "" which means normal-visual-op
    key = "<C-m>";
    action = ":!make<CR>";
  }
  {
    # Mode can be a string or a list of strings
    mode = "n";
    key = "<leader>p";
    action = "require('my-plugin').do_stuff";
    lua = true;
    # Note that all of the mapping options are now under the `options` attrs
    options = {
      silent = true;
      desc = "My plugin does stuff";
    };
  }
];

    # ...plugins...
    plugins = {
      telescope.enable = true;
      harpoon = {  # Hi Prime :)
        enable = true;
        keymaps.addFile = "<leader>a";
      };

      lsp = {
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            K = "hover";
          };
        };
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          nil_ls.enable = true;
        };
      };
    };

    # ... and even highlights and autocommands !
    highlight.ExtraWhitespace.bg = "red";
    match.ExtraWhitespace = "\\s\\+$";
    autoCmd = [
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2";
      }
    ];
  };
}
