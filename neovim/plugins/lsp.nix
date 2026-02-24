{
  programs.nixvim = {
    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>F";
        options.desc = "Implement fix";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      }
    ];
    lsp.inlayHints.enable = true;
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
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

        # enabledServers = [{
        #   name = "arduino_language_server";
        #   extraOptions = {
        #     cmd = [ "arduino-language-server" ];
        #     capabilities = [
        #       "default_capabilities.textDocument.semanticTokens = vim.NIL"
        #       "default_capabilities.workspace.semanticTokens = vim.NIL"
        #     ];
        #   };
        # }];

        servers = {
          tinymist.enable = true;
          ts_ls.enable = true;
          nixd = {
            enable = true;
          };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          pylsp = {
            enable = true;
            package = null;
          };

          ruff = {
            enable = true;
            # onAttach.function = ''
            #   if client.name == 'ruff' then
            #     -- Disable hover in favor of Pyright
            #     client.server_capabilities.hoverProvider = false
            #   end
            # '';
          };
          clangd.enable = true;
          lua_ls.enable = true;
          ruby_lsp.enable = true;
        };
      };
      lsp-signature.enable = true;
    };
  };
}
