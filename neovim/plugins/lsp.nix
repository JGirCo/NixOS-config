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
          typst-lsp.enable = true;
          nil-ls = {
            enable = true;
            # onAttach.function = ''
            #   navic.attach(client, bufnr)
            #   navbuddy.attach(client, bufnr)'';
          };
          rust-analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          ruff-lsp = { enable = true; };
          clangd.enable = true;
          lua-ls.enable = true;
        };
      };
    };
  };
}
