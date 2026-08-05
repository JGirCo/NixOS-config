{
  pkgs,
  lib,
  theme,
  colors,
  ...
}:

let

  p10k = builtins.readFile ./p10k.zsh;
  poweroffWithPrompt = pkgs.writeShellScriptBin "poweroffWithPrompt" ''
    ${pkgs.gum}/bin/gum confirm "Power off?" \
    --no-show-help \
    --prompt.foreground "#${colors.text2}" \
    --selected.foreground "#${colors.base}" \
    --selected.background "#${colors.focused}" \
    --unselected.foreground "#${colors.base}" \
    --unselected.background "#${colors.inactive}" \
    && poweroff
  '';
  rebootWithPrompt = pkgs.writeShellScriptBin "rebootWithPrompt" ''
    ${pkgs.gum}/bin/gum confirm "Reboot?" \
    --no-show-help \
    --prompt.foreground "#${colors.text2}" \
    --selected.foreground "#${colors.base}" \
    --selected.background "#${colors.focused}" \
    --unselected.foreground "#${colors.base}" \
    --unselected.background "#${colors.inactive}" \
    && reboot
  '';
  themeSwitcher = pkgs.writeShellScriptBin "themeSwitcher" ''
    THEME=$(${pkgs.gum}/bin/gum choose \
    --no-show-help \
    --item.foreground "#${colors.base}" \
    --padding "1 1" \
    --header.foreground "#${colors.text2}" \
    --selected.foreground "#${colors.base}" \
    --selected.background "#${colors.focused}" \
    --cursor.foreground "#${colors.focused}" \
    --item.foreground "#${colors.inactive}" \
    "ayu-light" "catppuccin-macchiato" "catppuccin-latte" "dracula" "everforest-light" "gruvbox-dark-medium" "gruvbox-light-medium" "gruvbox-light-soft" "kanagawa-light" "melange" "oxocarbon-light" "rebecca" "rose-pine-dawn" "rose-pine" "saga" "template" "tokyo-night-moon" "trans")
    if [ -n "$THEME" ]; then
      nh home switch -c $THEME
    fi
  '';
in
{
  home.packages = [ themeSwitcher ];

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
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        themes = "${themeSwitcher}/bin/themeSwitcher";
        mktmp = "cd $(mktemp -d)";
        update = "sudo nixos-rebuild switch --flake ~/.nixos/";
        rebuildHome = "home-manager switch --flake ~/.nixos/";
        editSystem = "nvim ~/.nixos/configuration.nix";
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
        rcp = "${pkgs.rsync}/bin/rsync -av --info=progress2";
        rmv = "${pkgs.rsync}/bin/rsync -av --remove-source-files --info=progress2";
        reboot = "${rebootWithPrompt}/bin/rebootWithPrompt";
        poweroff = "${poweroffWithPrompt}/bin/poweroffWithPrompt";
      };
      initContent = lib.strings.concatStrings [
        p10k
        ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ''

        ''
          bindkey "^[k" history-beginning-search-backward
          bindkey "^[j" history-beginning-search-forward
        ''

        ''
          eval "$(direnv hook zsh)"
        ''
      ];
    };
    # starship = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };
  };
}
