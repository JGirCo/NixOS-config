{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      starter = { };
      ai = { };
      icons = { };
      pairs = { };
      surround = {
        mappings = {
          add = "sa";
          delete = "sd";
          find = "sf";
          find_left = "sF";
          highlight = "sh";
          replace = "sr";
          suffix_last = "l";
          suffix_next = "n";
        };
      };
      animate = { cursor.enable = false; };
      notify = { };
      git = { };
      indentscope = { };
    };
  };
}
