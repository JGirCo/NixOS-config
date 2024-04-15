{ pkgs, ... }:

let
     norgPkg = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "my-old-revision";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "07518c851b0f12351d7709274bbbd4ecc1f089c7";
     }) {};

     norg = norgPkg.vimPlugins.neorg;
in
{
  programs.nixvim = {
    files."after/ftplugin/norg.lua" = {
      localOpts.conceallevel = 1;

      keymaps = [{
        mode = "n";
        key = "<C-g>";
        action = ":Neorg toc<CR>";
        options.silent = true;
      }];
    };

    plugins.neorg = {
      enable = true;
      package = norg;
      lazyLoading = true;

      modules = {
        "core.defaults" = { __empty = null; };
        "core.dirman" = { config = { workspaces = { notes = "~/notes"; }; }; };
        "core.concealer".__empty = null;
        "core.completion".config.engine = "nvim-cmp";
        "core.qol.toc".config.close_after_use = true;
      };
    };
  };
}
