{ norgpkg, ... }: {
  programs.nixvim = {
    plugins.neorg = {
      enable = true;
      package = norgpkg.vimPlugins.neorg;
      # ... other config
    };
  };
}
