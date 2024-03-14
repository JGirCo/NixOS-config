{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };

        enabledServers = [
          {name = "arduino_language_server";
            extraOptions = {
              cmd = ["arduino-language-server"];
              capabilities = ["default_capabilities.textDocument.semanticTokens = vim.NIL"
              "default_capabilities.workspace.semanticTokens = vim.NIL"];
            };
          }
        ];

        servers = {
          rnix-lsp.enable = true;
          pylsp.enable = true;
          rust-analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          ruff-lsp.enable = true;
          clangd.enable = true;
          lua-ls.enable = true;
        };
      };
    };
  };
}
