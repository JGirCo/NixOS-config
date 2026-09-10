{ ... }:
{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = [ "n" ];
        key = "<Space>";
        action = "<NOP>";
        options = {
          silent = true;
          noremap = true;
          desc = "Disable space in normal mode";
        };
      }

      {
        mode = [ "n" ];
        key = "<esc>";
        action = ":noh<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Esc to clear search results";
        };
      }

      {
        mode = [ "n" ];
        key = "Y";
        action = "y$";
        options = {
          silent = true;
          noremap = true;
          desc = "Copy to end";
        };
      }

      {
        mode = [ "n" ];
        key = "j";
        action = "gj";
        options = {
          silent = true;
          noremap = true;
          desc = "Down, follows wrapped line";
        };
      }

      {
        mode = [ "n" ];
        key = "k";
        action = "gk";
        options = {
          silent = true;
          noremap = true;
          desc = "Up, follows wrapped line";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>h";
        action = "<C-w>h";
        options = {
          silent = true;
          noremap = true;
          desc = "Nav to left window";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>l";
        action = "<C-w>l";
        options = {
          silent = true;
          noremap = true;
          desc = "Nav to right window";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>j";
        action = "<C-w>j";
        options = {
          silent = true;
          noremap = true;
          desc = "Nav to bottom window";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>k";
        action = "<C-w>k";
        options = {
          silent = true;
          noremap = true;
          desc = "Nav to upper window";
        };
      }

      {
        mode = [ "n" ];
        key = "<M-h>";
        action = "<cmd>bp<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Previous buffer";
        };
      }

      {
        mode = [ "n" ];
        key = "<M-l>";
        action = "<cmd>bn<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Next buffer";
        };
      }

      {
        mode = [ "n" ];
        key = "<M-w>";
        action = "<cmd>bd<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Close buffer";
        };
      }

      {
        mode = [ "n" ];
        key = "L";
        action = "$";
        options = {
          silent = true;
          noremap = true;
          desc = "Jump to end";
        };
      }

      {
        mode = [ "n" ];
        key = "H";
        action = "^";
        options = {
          silent = true;
          noremap = true;
          desc = "Jump to first non whitespace character";
        };
      }
      {
        mode = "i";
        key = "<C-c>";
        action = "<Esc>b~ea";
        options = {
          silent = true;
          noremap = true;
          desc = "Change the case of the first letter of the current word";
        };
      }
      {
        mode = [ "n" ];
        key = "z=";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options = {
          silent = true;
          desc = "LTeX spelling/grammar suggestions";
        };
      }
      {
        mode = [ "n" ];
        key = "zg";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options = {
          silent = true;
          desc = "LTeX add word to dictionary";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>se";
        action = "<cmd>LtexLang en-US<CR>";
        options = {
          silent = true;
          desc = "LTeX language: English";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>ss";
        action = "<cmd>LtexLang es<CR>";
        options = {
          silent = true;
          desc = "LTeX language: Spanish";
        };
      }
    ];
  };
}
