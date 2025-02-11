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
          tinymist.enable = true;
          nixd = { enable = true; };
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          # pylsp = {
          #   enable = true;
          #   settings.plugins = {
          #     jedi.enabled = true;
          #     jedi_completion.enabled = true;
          #     jedi_definition.enabled = true;
          #     jedi_hover.enabled = true;
          #     pyright.enabled = true;
          #   };
          # };
          pyright = {
            enable = true;
            extraOptions.settings = {
              # Using Ruff's import organizer
              pyright.disableOrganizeImports = true;
              python.analysis = {
                # Ignore all files for analysis to exclusively use Ruff for linting
                ignore.__raw = "{ '*' }";
              };
            };
          };

          ruff = {
            enable = true;
            onAttach.function = ''
              if client.name == 'ruff' then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            '';
          };
          clangd.enable = true;
          lua_ls.enable = true;
        };
      };
    };
  };
}
