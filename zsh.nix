{
  pkgs,
  lib,
  colors,
  ...
}:

let
  # Styled wrapper for gum choose
  themesSet = import ./themes.nix;

  # Automatically extract all theme name keys into a list
  themes = builtins.attrNames themesSet;
  gumChoose = pkgs.writeShellScriptBin "gumchoose" ''
    exec ${pkgs.gum}/bin/gum choose \
      --no-show-help \
      --padding "1 1" \
      --header.foreground "#${colors.text}" \
      --selected.foreground "#${colors.base}" \
      --selected.background "#${colors.focused}" \
      --cursor.foreground "#${colors.focused}" \
      --item.foreground "#${colors.inactive}" \
      "$@"
  '';

  # Helper for styled confirmation prompts
  mkConfirm =
    name: prompt: action:
    pkgs.writeShellScriptBin name ''
      ${pkgs.gum}/bin/gum confirm "${prompt}" \
        --no-show-help \
        --prompt.foreground "#${colors.text}" \
        --selected.foreground "#${colors.base}" \
        --selected.background "#${colors.focused}" \
        --unselected.foreground "#${colors.base}" \
        --unselected.background "#${colors.inactive}" \
        && ${action}
    '';

  poweroffWithPrompt = mkConfirm "poweroffWithPrompt" "Power off?" "poweroff";
  rebootWithPrompt = mkConfirm "rebootWithPrompt" "Reboot?" "reboot";

  themeSwitcher = pkgs.writeShellScriptBin "themeSwitcher" ''
    THEME=$(${gumChoose}/bin/gumchoose ${lib.escapeShellArgs themes})

    if [ -n "$THEME" ]; then
      nh home switch -c "$THEME"

      # Restart apps that cache their theme at startup
      pkill -x nautilus qbittorrent org.gnome.Nautilus 2>/dev/null || true
      killall -q gtk-query-settings gsettings-data-convert 2>/dev/null || true
      echo "Theme switched to $THEME — GTK/Qt apps restarted."
    fi
  '';
in
{
  home.packages = [
    themeSwitcher
    gumChoose
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
      changeDirWidget.command = "${pkgs.fd}/bin/fd --type d --hidden --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
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
            NixOS = " ";
            Linux = " ";
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
          name = "zsh-system-clipboard";
          src = pkgs.zsh-system-clipboard;
          file = "share/zsh-system-clipboard/zsh-system-clipboard.zsh";
        }
        {
          name = "nix-zsh-completions";
          src = pkgs.nix-zsh-completions;
          file = "share/zsh/plugins/nix-zsh-completions/nix-zsh-completions.plugin.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
          file = "share/zsh/zsh-autopair/autopair.zsh";
        }
        {
          name = "you-should-use";
          src = pkgs.zsh-you-should-use;
          file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
        }
        {
          name = "zsh-defer";
          src = pkgs.zsh-defer;
          file = "share/zsh-defer/zsh-defer.plugin.zsh";
        }
      ];
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        themes = "${themeSwitcher}/bin/themeSwitcher";
        mktmp = "cd $(mktemp -d)";
        editSystem = "nvim ~/.nixos/configuration.nix";
        ardUpload = "arduino-cli compile --upload";
        ardMonitor = "arduino-cli monitor -p /dev/ttyUSB0 -c 115200";
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
      initExtra = ''
        # Enable Zsh native Vi mode
        bindkey -v
        export KEYTIMEOUT=1

        # Preserve custom history navigation keybindings
        bindkey "^[k" history-beginning-search-backward
        bindkey "^[j" history-beginning-search-forward

        # fzf-tab completion preview configuration
        zstyle ':fzf-tab:*' use-fzf-default-opts yes
        zstyle ':completion:*' menu no
        # zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.eza}/bin/eza -1 -a --color=always $realpath'
        # zstyle ':fzf-tab:complete:systemctl:*' fzf-preview 'systemctl status $word'
      '';
    };
  };

}
