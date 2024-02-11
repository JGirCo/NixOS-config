{ config, pkgs, ... }:

{
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      # syntaxHighlighting.enable = true;
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
        export PATH="$PWD/diagslave/x86_64-linux-gnu:$PATH"
        export PATH="$PWD/modpoll/modpoll/x86_64-linux-gnu:$PATH"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
}
