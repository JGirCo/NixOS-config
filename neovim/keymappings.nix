{ config, lib, ... }: {
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
        key = "<leader>s";
        action = ":w<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Save";
        };
      }

      {
        mode = [ "n" ];
        key = "<leader>h";
        action = "<C-w>h";
        options = {
          silent = true;
          noremap = true;
          desc = "nav to left window";
        };
      }
      {
        mode = [ "n" ];
        key = "<leader>j";
        action = "<C-w>j";
        options = {
          silent = true;
          noremap = true;
          desc = "nav to right window";
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
        key = "K";
        action = "^";
        options = {
          silent = true;
          noremap = true;
          desc = "Jump to start";
        };
      }
    ];
  };
}
