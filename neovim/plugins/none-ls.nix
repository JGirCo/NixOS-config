{
  programs.nixvim.plugins = {
    none-ls = {
      enable = true;
      sources = {
        formatting = {
          nixfmt.enable = true;
          black.enable = true;
          rufo.enable = true;
          prettier.enable = true;
          prettier.disableTsServerFormatter = true;
          typstyle.enable = true;
        };
        diagnostics = { };
      };
    };
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = "fallback";
          timeout_ms = 500;
        };
        notify_on_error = true;

        formatters_by_ft = {
          css = [ "prettier" ];
          html = [ "prettier" ];
          json = [ "prettier" ];
          lua = [ "stylua" ];
          markdown = [ "prettier" ];
          nix = [ "nixfmt" ];
          ruby = [ "rufo" ];
          rust = [ "rustfmt" ];
          typst = [ "typstyle" ];
          python = [ "black" ];
        };
      };
    };
  };
}
