{
  programs.nixvim.plugins = {
    treesitter = {
      enable = false;
      nixvimInjections = true;

      folding.enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensureInstalled = [
          "markdown"
          "markdown_inline"
          "htl"
          "yaml"
          "typst"
          "nix"
          "arduino"
          "python"
          "rust"
          "norg"
        ];
      };
    };

    # treesitter-refactor = {
    #   enable = true;
    #   settings.highlightDefinitions.enable = true;
    # };

    hmts.enable = true;
  };
  # Enable native highlighting for the buffers you use
  extraConfigLua = ''
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        -- Try to start native treesitter highlighting
        local ok, _ = pcall(vim.treesitter.start)
        if not ok then
          -- Fallback to standard regex highlighting if parser is missing
          vim.cmd("syntax on")
        end
      end,
    })
  '';
}
