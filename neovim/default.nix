{ config, ... }:
let
  nvim-spell-es-utf8-dictionary = builtins.fetchurl {
    url = "http://ftp.vim.org/vim/runtime/spell/es.utf-8.spl";
    sha256 = "1qvv6sp4d25p1542vk0xf6argimlss9c7yh7y8dsby2wjan3fdln";
  };

in {
  imports = [
    ./debugging.nix
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

    # Highlight and remove extra white spaces
    match.ExtraWhitespace = "\\s\\+$";
  };
}
