{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>F" = {
              action = "setloclist";
              desc = "Open diagnostic quick[F]ix list";
            };
            "<leader>d" = {
              action = "open_float";
              desc = "Open diagnostic float";
            };
            "<leader>n" = {
              action = "goto_next";
              desc = "Next diagnostic";
            };
            "<leader>N" = {
              action = "goto_prev";
              desc = "Prev diagnostic";
            };
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

        enabledServers = [{
          name = "arduino_language_server";
          extraOptions = {
            cmd = [ "arduino-language-server" ];
            capabilities = [
              "default_capabilities.textDocument.semanticTokens = vim.NIL"
              "default_capabilities.workspace.semanticTokens = vim.NIL"
            ];
          };
        }];

        servers = {
          typst_lsp.enable = true;
          nil_ls = {
            enable = true;
          };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          ruff_lsp = { enable = true; };
          clangd.enable = true;
          lua_ls.enable = true;
        };
      };
    };
  };
}
