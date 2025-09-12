{
  programs.nixvim = {
    plugins.barbar = {
      enable = true;
      keymaps = {
        next.key = "<M-l>";
        previous.key = "<M-h>";
        close.key = "<M-w>";
      };
      settings = {
        highlight_visible = true;
        icons = {
          # separator = {
          #   left = "";
          #   right = "";
          # };
          # separator_at_end = false;
        };
      };
    };
  };
}
