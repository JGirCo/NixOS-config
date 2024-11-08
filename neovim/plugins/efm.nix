{
  programs.nixvim.plugins = {
    lsp.servers.efm = {
      enable = true;
      extraOptions.init_options = {
        documentFormatting = true;
        documentRangeFormatting = true;
        hover = true;
        documentSymbol = true;
        codeAction = true;
        completion = true;
      };
    };

    lsp-format = {
      enable = true;
      lspServersToEnable = [ "efm" "nil_ls" ];
    };

    efmls-configs = {
      enable = true;
      setup = {
        python.formatter = "ruff";
        python.linter = "ruff";
        nix.formatter = "nixfmt";
        nix.linter = "statix";
        "c++".formatter = "clang_format";
        "c++".linter = "gcc";
      };
    };
  };
}
