{ pkgs, ... }:
let
  esThes = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Konfekt/vim-thesauri/master/es.ths";
    sha256 = "028525a94e90542df6c4af988221ecb4862509aab39aaaa559825a009651e1e0";
  };
  enThes = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Konfekt/vim-thesauri/master/en.ths";
    sha256 = "953a632f719004f8a2217e6dff5aaaed088adc547e400f4a3813099f1daf7173";
  };
in
{
  imports = [
    ./autocommands.nix
    ./commands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
    ./todo.nix
  ];

  home.shellAliases.v = "nvim";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "markdown"
          "tex"
          "typst"
        ];
        command = "setlocal thesaurus=${enThes},${esThes}";
      }
    ];

    keymaps = [
      {
        mode = [ "i" ];
        key = "<F7>";
        options.desc = "Thesaurus completion";
        action = "<C-x><C-t>";
      }
    ];
  };
}
