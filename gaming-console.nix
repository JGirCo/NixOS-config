{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  retroSystems = [
    {
      dir = "SNES";
      core = "snes9x";
      romsDir = "snes";
    }
    {
      dir = "GBA";
      core = "mgba";
      romsDir = "gba";
    }
    {
      dir = "PS1";
      core = "swanstation";
      romsDir = "psx";
    }
    {
      dir = "PSP";
      core = "ppsspp";
      romsDir = "psp";
    }
    {
      dir = "Gamecube";
      core = "dolphin";
      romsDir = "gc";
    }
  ];

  actkbdBindings = [
    {
      keys = [ 224 ];
      events = [ "key" ];
      command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
    }
    {
      keys = [ 225 ];
      events = [ "key" ];
      command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
    }
    {
      keys = [ 113 ];
      events = [ "key" ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
    }
    {
      keys = [ 114 ];
      events = [
        "key"
        "rep"
      ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
    }
    {
      keys = [ 115 ];
      events = [
        "key"
        "rep"
      ];
      command = "${pkgs.util-linux}/bin/runuser -u jgirco -- ${pkgs.bash}/bin/bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u); ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'";
    }
  ];

  mkGamescopeConsoleSpecialisation =
    {
      name,
      spawn,
      extraPackages ? [ ],
    }:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      sessionScript = pkgs.writeShellScript "gamescope-console-${name}-session" ''
        for svc in waybar awww-daemon iwgtk apply-theme; do
          ${pkgs.systemd}/bin/systemctl --user mask --runtime "$svc.service" 2>/dev/null || true
        done

        export vk_khr_present_wait=false
        export ENABLE_GAMESCOPE_WSI=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=gamescope
        export STEAM_FRAME_FORCE_CLOSE=1

        ${pkgs.systemd}/bin/systemctl --user start pipewire.service wireplumber.service || true
        ${pkgs.systemd}/bin/systemctl --user import-environment \
          WAYLAND_DISPLAY DISPLAY XDG_RUNTIME_DIR \
          XDG_SESSION_TYPE XDG_CURRENT_DESKTOP \
          PULSE_RUNTIME_PATH PULSE_SERVER || true
        ${pkgs.systemd}/bin/systemctl --user start graphical-session.target || true
        ${pkgs.systemd}/bin/systemctl --user start sunshine.service || true

        exec ${spawn}
      '';
    in
    {
      environment.systemPackages = extraPackages;

      programs.gamescope = {
        enable = true;
        enableWsi = true;
      };

      programs.steam.enable = true;

      services.sunshine = {
        enable = true;
        autoStart = lib.mkForce true;
        capSysAdmin = lib.mkForce true;
      };

      services.actkbd = {
        enable = true;
        bindings = actkbdBindings;
      };

      services.greetd.settings.default_session = {
        user = "jgirco";
        command = lib.mkForce "${pkgs.gamescope}/bin/gamescope -f --xwayland-count 1 -w 2560 -h 1600 -W 2560 -H 1600 --force-grab-cursor -- ${sessionScript}";
      };

      services.logind.settings.Login = {
        HandlePowerKey = lib.mkForce "poweroff";
      };
    };

  esde = pkgs.appimageTools.wrapType2 {
    pname = "es-de";
    version = "3.4.1";
    src = pkgs.fetchurl {
      url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
      hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
    };
  };

  esdeConsole = pkgs.writeShellScriptBin "esde-console" ''
        set -euo pipefail
        ROMROOT="$HOME/Games/ROMS"
        ESDEROMS="$HOME/ROMs"
        CORESDIR="$HOME/.config/retroarch/cores"
        STEAMDIR="$HOME/.local/share/Steam/steamapps"
        mkdir -p "$CORESDIR" "$ESDEROMS" "$ESDEROMS/steam" "$HOME/.local/bin" "$HOME/.config/retroarch"

        ${lib.concatMapStringsSep "\n" (
          s:
          "ln -sf ${pkgs.libretro.${s.core}}/lib/retroarch/cores/${s.core}_libretro.so \"$CORESDIR/${s.core}_libretro.so\""
        ) retroSystems}

        ${lib.concatMapStringsSep "\n" (
          s:
          "if [ -d \"$ROMROOT/${s.dir}\" ]; then ln -sfn \"$ROMROOT/${s.dir}\" \"$ESDEROMS/${s.romsDir}\"; fi"
        ) retroSystems}

        cat > "$HOME/.config/retroarch/niri-console.cfg" <<'CFG'
    video_fullscreen = "true"
    video_windowed_fullscreen = "true"
    CFG
        rm -f "$HOME/.local/bin/retroarch"
        cat > "$HOME/.local/bin/retroarch" <<EOF
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.retroarch}/bin/retroarch --appendconfig="\$HOME/.config/retroarch/niri-console.cfg" "\$@"
    EOF
        chmod +x "$HOME/.local/bin/retroarch"

        rm -f "$ESDEROMS/steam"/*.desktop

        if [ -d "$STEAMDIR" ]; then
          for mf in "$STEAMDIR"/appmanifest_*.acf; do
            [ -e "$mf" ] || continue
            appid=$(sed -n 's/.*"appid"[[:space:]]*"\([0-9]*\)".*/\1/p' "$mf" | head -1)
            name=$(sed -n 's/.*"name"[[:space:]]*"\(.*\)".*/\1/p' "$mf" | head -1)
            [ -n "$appid" ] && [ -n "$name" ] || continue
        cat > "$ESDEROMS/steam/$name.desktop" <<EOF
        [Desktop Entry]
        Type=Application
        Name=$name
        Exec=${pkgs.steam}/bin/steam -silent steam://rungameid/$appid
        EOF
          done
        fi

        STEAM_FRAME_FORCE_CLOSE=1 ${pkgs.steam}/bin/steam -silent -nochatui -nofriendsui &
        sleep 2

        exec ${esde}/bin/es-de
  '';
in
{
  specialisation = {
    "Gaming-Console".configuration = mkGamescopeConsoleSpecialisation {
      name = "esde";
      spawn = "${esdeConsole}/bin/esde-console";
      extraPackages = [
        esde
        (pkgs.retroarch.withCores (
          cores: with cores; [
            snes9x
            mgba
            ppsspp
            swanstation
            dolphin
          ]
        ))
      ];
    };
  };
}
