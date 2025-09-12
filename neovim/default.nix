{ config, ... }:
let
  nvim-spell-es-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/pub/vim/runtime/spell/sk.utf-8.spl";
    sha256 = "0z2kc2n5kidqyi62155wsclw00726klpw9nmx2g37wmn89p374dq";
  };

in {
  imports = [
    # ./debugging.nix
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
    ./todo.nix
    ./colors.nix
  ];

  home.shellAliases.v = "nvim";
  home.file."${config.xdg.configHome}/nvim/spell/es.utf-8.spl".source =
    nvim-spell-es-utf8-dictionary;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };
}
