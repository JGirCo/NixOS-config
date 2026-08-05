{ pkgs, ... }:
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
            settings = {
              check.command = "clippy";
            };
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
          lua_ls.enable = true;
          ruby_lsp.enable = true;
          ltex = {
            enable = true;
            package = pkgs.ltex-ls-plus;
            cmd = [ "ltex-ls-plus" ];
            filetypes = [
              "markdown"
              "tex"
              "typst"
              "typ"
            ];
            settings = {
              ltex = {
                language = "en-US";
                enabled = [
                  "latex"
                  "tex"
                  "bib"
                  "markdown"
                  "html"
                  "typst"
                  "typ"
                ];
              };
            };
            onAttach.function = ''
              client.handlers["$/progress"] = function() end
            '';
          };
        };
      };
      lsp-signature.enable = true;
      ltex-extra = {
        enable = true;
        settings = {
          init_check = true;
          load_langs = [
            "en-US"
            "es"
          ];
          path = ".ltex";
        };
      };
    };
  };
}
