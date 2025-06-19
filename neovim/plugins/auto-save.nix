{
  programs.nixvim = {
    plugins.auto-save = {
      enable = true;
      settings.condition = ''
        function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          if utils.not_in(fn.getbufvar(buf, "&filetype"), {"norg", "markdown", "tex"}) then
            return false
          end
          return true
        end
      '';

    };
  };
}
