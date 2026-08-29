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

  # Build a declarative store linkFarm for cores—no runtime bash loops required
  retroCoresDir = pkgs.linkFarm "esde-retroarch-cores" (
    map (s: {
      name = "${s.core}_libretro.so";
      path = "${pkgs.libretro.${s.core}}/lib/retroarch/cores/${s.core}_libretro.so";
    }) retroSystems
  );

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
        export STEAM_FRAME_FORCE_CLOSE=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=gamescope

        ${pkgs.systemd}/bin/systemctl --user start pipewire.service wireplumber.service || true
        ${pkgs.systemd}/bin/systemctl --user import-environment \
          WAYLAND_DISPLAY DISPLAY XDG_RUNTIME_DIR \
          XDG_SESSION_TYPE XDG_CURRENT_DESKTOP \
          PULSE_RUNTIME_PATH PULSE_SERVER || true
        ${pkgs.systemd}/bin/systemctl --user start graphical-session.target || true
        ${pkgs.systemd}/bin/systemctl --user start sunshine.service || true

        exec ${spawn}
      '';
      gamescopeLaunch = pkgs.writeShellScript "gamescope-console-${name}-launch" ''
        set -euo pipefail

        tvStatus="disconnected"
        for f in /sys/class/drm/card*-HDMI-A-1/status; do
          [ -e "$f" ] || continue
          tvStatus=$(cat "$f")
        done

        if [ "$tvStatus" = "connected" ]; then
          # NVIDIA driving the HDMI port
          gsArgs=(--prefer-vk-device 10de:28e0 -O HDMI-A-1)
        else
          # AMD driving the built-in screen
          gsArgs=(--prefer-vk-device 1002:1900 -O eDP-2)
        fi

        exec ${pkgs.gamescope}/bin/gamescope -f --xwayland-count 1 -w 2560 -h 1600 --force-grab-cursor "''${gsArgs[@]}" -- ${sessionScript} > /tmp/gamescope-session.log 2>&1
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
        command = lib.mkForce "${gamescopeLaunch}";
      };

      services.logind.settings.Login = {
        HandlePowerKey = lib.mkForce "poweroff";
      };
      systemd.services."kmsconvt@tty1".enable = false;
      systemd.services."kmsconvt@tty2".enable = false;
    };

  esde = pkgs.appimageTools.wrapType2 {
    pname = "es-de";
    version = "3.4.1";
    src = pkgs.fetchurl {
      url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
      hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
    };
  };

  # Isolated script for parsing Steam manifests cleanly
  syncSteamGames = pkgs.writeShellScriptBin "sync-steam-games" ''
        set -euo pipefail
        STEAMDIR="$HOME/.local/share/Steam/steamapps"
        ESDEROMS="$HOME/ROMs"
        mkdir -p "$ESDEROMS/steam"
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
  '';

  # Lean session launcher script
  esdeConsole = pkgs.writeShellScriptBin "esde-console" ''
        set -euo pipefail
        ROMROOT="$HOME/Games/ROMS"
        ESDEROMS="$HOME/ROMs"

        mkdir -p "$HOME/.config/retroarch" "$ESDEROMS" "$HOME/.local/bin"

        # Link the pre-built core farm straight into RetroArch's path
        ln -sfn "${retroCoresDir}" "$HOME/.config/retroarch/cores"

        ${lib.concatMapStringsSep "\n" (
          s:
          "if [ -d \"$ROMROOT/${s.dir}\" ]; then ln -sfn \"$ROMROOT/${s.dir}\" \"$ESDEROMS/${s.romsDir}\"; fi"
        ) retroSystems}

        cat > "$HOME/.config/retroarch/niri-console.cfg" <<'CFG'
    video_fullscreen = "true"
    video_windowed_fullscreen = "true"
    CFG

        cat > "$HOME/.local/bin/retroarch" <<EOF
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.retroarch}/bin/retroarch --appendconfig="\$HOME/.config/retroarch/niri-console.cfg" "\$@"
    EOF
        chmod +x "$HOME/.local/bin/retroarch"

        # Update Steam shortcuts
        ${syncSteamGames}/bin/sync-steam-games

        # Spawn Steam silently in the background and launch ES-DE
        ${pkgs.steam}/bin/steam -silent -nochatui -nofriendsui &
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
