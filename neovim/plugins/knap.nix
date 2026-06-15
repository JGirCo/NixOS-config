{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ { plugin = pkgs.vimPlugins.plantuml-nvim; } ];
    extraConfigLua = ''
      require('plantuml').setup({
      viewer = "${pkgs.vipsdisp}/bin/vipsdisp",
      })'';
    # keymaps = [
    #   {
    #     mode = [ "n" ];
    #     key = "<F5>";
    #     action = '':lua require("knap").process_once()<CR>'';
    #     options = {
    #       silent = true;
    #       noremap = true;
    #       desc = "Preview document once";
    #     };
    #   }
    #
    #   {
    #     mode = [ "n" ];
    #     key = "<F7>";
    #     action = '':lua require("knap").toggle_autopreviewing()<CR>'';
    #     options = {
    #       silent = true;
    #       noremap = true;
    #       desc = "Preview document once";
    #     };
    #   }
    #
    # ];
  };
}
