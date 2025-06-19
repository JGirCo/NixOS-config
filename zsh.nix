{ pkgs, lib, ... }:

let
  p10k = builtins.readFile ./p10k.zsh;
  rebootWithPrompt = pkgs.writeShellScriptBin "rebootWithPrompt" ''
    read -p "reboot? " -n 1 -r
    echo "\r"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo "rebooting..."
      sleep 2
      reboot
    fi
  '';

in {
  programs = {
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };
    zsh = {
      enable = true;
      plugins = [{
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }];
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        mktmp = "cd $(mktemp -d)";
        update = "sudo nixos-rebuild switch --flake ~/.nixos/";
        rebuildHome = "home-manager switch --flake ~/.nixos/";
        editSystem = "nvim ~/etc/nixos/configuration.nix";
        ardUpload = "arduino-cli compile --upload";
        ardMonitor = "arduino-cli monitor -p /dev/ttyUSB0 -c 115200";
        cd = "z";
        ".." = "cd ..";
        "..." = "cd ../../";
        "4." = "cd ../../../";
        "5." = "cd ../../../../";
        mkdir = "mkdir -pv";
        py = "python";
        nd = "nix develop -c zsh";
        thesis = "cd ~/Documents/thesis && nvim index.norg";
        rcp = "${pkgs.rsync}/bin/rsync -av --info=progress2";
        rmv =
          "${pkgs.rsync}/bin/rsync -av --remove-source-files --info=progress2";
        reboot = "${rebootWithPrompt}/bin/rebootWithPrompt";
        poweroff = "echo shutting down... && sleep 30 && poweroff";
      };
      initContent = lib.strings.concatStrings [
        p10k
        ''
          export PATH="$HOME/.emacs.d/bin:$PATH"
          export PATH="$PWD/diagslave/x86_64-linux-gnu:$PATH"
          export PATH="$PWD/modpoll/modpoll/x86_64-linux-gnu:$PATH"
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ''

        ''
          bindkey "^[k" history-beginning-search-backward
          bindkey "^[j" history-beginning-search-forward
        ''
      ];
    };
  };
}
