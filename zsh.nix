{
  pkgs,
  lib,
  theme,
  colors,
  ...
}:

let

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

      # Restart apps that cache their theme at startup.
      pkill -x nautilus 2>/dev/null || true
      pkill -x qbittorrent 2>/dev/null || true
      pkill -x org.gnome.Nautilus 2>/dev/null || true
      systemctl --user restart swaync.service 2>/dev/null || true
      killall -q gtk-query-settings gsettings-data-convert 2>/dev/null || true
      echo "Theme switched to $THEME — GTK/Qt apps restarted."
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
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = " $os $directory $git_branch $git_commit $git_state $git_metrics $git_status $line_break $character";
        right_format = "$status $cmd_duration $jobs $direnv $nix_shell";

        os = {
          disabled = false;
          format = "$symbol ";
          style = "bold white";
          symbols = {
            NixOS = "󱄅 ";
            Linux = "󱄅 ";
          };
        };

        directory = {
          style = "bold cyan";
          truncation_length = 3;
          truncate_to_repo = true;
          repo_root_style = "bold cyan";
          before_repo_root_style = "bold cyan";
        };

        git_branch = {
          symbol = " ";
          style = "bold purple";
          format = "[$symbol$branch(:$remote_branch)]($style) ";
        };

        git_commit = {
          style = "bold green";
          format = "[$hash$tag]($style) ";
        };

        git_state = {
          style = "bold yellow";
        };

        git_metrics = {
          disabled = false;
          added_style = "bold green";
          deleted_style = "bold red";
        };

        git_status = {
          style = "bold yellow";
        };

        status = {
          disabled = false;
          format = "[$symbol]($style) ";
          symbol = "✘";
          success_symbol = "";
          style = "bold red";
        };

        cmd_duration = {
          min_time = 3000;
          format = "[$duration]($style) ";
          style = "bold white";
          show_milliseconds = false;
        };

        direnv = {
          format = "$symbol";
          symbol = "󱁿 ";
          style = "bold yellow";
        };

        nix_shell = {
          disabled = false;
        };

        jobs = {
          disabled = false;
        };

        character = {
          success_symbol = "[❯](bold green) ";
          error_symbol = "[❯](bold red) ";
          vimcmd_symbol = "[❮](bold green) ";
          vimcmd_visual_symbol = "[V](bold yellow) ";
        };
      };
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
      initContent = ''
        bindkey "^[k" history-beginning-search-backward
        bindkey "^[j" history-beginning-search-forward

        eval "$(direnv hook zsh)"
      '';
    };
  };
}
