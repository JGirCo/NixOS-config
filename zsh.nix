{ config, pkgs, ... }:

{
  home-manager.users.juanma = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        editSystem = "nvim ~/etc/nixos/configuration.nix";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "zoxide" "sudo" ];
        theme = "lukerandall";
      };
      initExtra = ''
        export PATH="$HOME/.emacs.d/bin:$PATH"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
  };
}
