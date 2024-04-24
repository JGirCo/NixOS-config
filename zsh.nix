{ config, pkgs, lib, ... }:

let p10k = builtins.readFile ./p10k.zsh;
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/etc/nixos/";
      rebuildHome = "home-manager switch --flake ~/etc/nixos/";
      editSystem = "nvim ~/etc/nixos/configuration.nix";
      ardUpload = "arduino-cli compile && arduino-cli upload";
      ardMonitor = "arduino-cli monitor -p /dev/ttyUSB0 -c 115200";
      cd = "z";
      py = "python";
      nd = "nix develop -c zsh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zoxide" "sudo" "colored-man-pages" ];
    };
    initExtra = lib.strings.concatStrings [
      ''
        export PATH="$HOME/.emacs.d/bin:$PATH"
        export PATH="$PWD/diagslave/x86_64-linux-gnu:$PATH"
        export PATH="$PWD/modpoll/modpoll/x86_64-linux-gnu:$PATH"
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      ''
      p10k
    ];
  };
}
