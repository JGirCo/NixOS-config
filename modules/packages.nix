# System packages: the global environment.systemPackages list.
# Also defines the GPUOffloadApp/patchDesktop helpers used to wrap desktop
# entries with `nvidia-offload` (so they run on the discrete GPU).
{ pkgs, lib, ... }:
let
  inherit (pkgs) coreutils gnused;

  patchDesktop =
    pkg: from: to:
    lib.hiPrio (
      pkgs.runCommand "offload-${pkg.name}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        for file in ${pkg}/share/applications/*.desktop; do
          base=$(${coreutils}/bin/basename "$file")
          ${gnused}/bin/sed 's#${from}#${to}#g' "$file" > $out/share/applications/$base
        done
      ''
    );

  GPUOffloadApp = pkg: (patchDesktop pkg "^Exec=" "Exec=nvidia-offload ");
in
{
  environment.systemPackages = with pkgs; [
    # Basic tools
    git
    wget
    gcc
    rsync
    gnumake
    ripgrep
    zip
    unzip
    gh
    fd
    coreutils
    luajit
    wine
    exfatprogs
    lm_sensors
    wlr-randr

    #System tools
    keyd
    acpi
    pamixer
    playerctl
    udiskie
    ffmpeg

    #Network tools
    mosquitto

    # Terminal Tools
    libqalculate
    translate-shell
    plantuml
    openpomodoro-cli
    opencode
    claude-code
    ncdu
    ytermusic
    ouch-rar

    # GUI Tools
    rpi-imager
    kicad
    python313Packages.python-lsp-server
    python313Packages.python-lsp-black
    blockbench
    pavucontrol
    ripdrag
    zotero
    vipsdisp
    libreoffice
    nautilus
    ungoogled-chromium
    qbittorrent
    steam-rom-manager

    # Miscelaneous
    mpris-scrobbler
    tridactyl-native
    nix-prefetch-github
    lenovo-legion
    gtklock

    #games
    prismlauncher

    (GPUOffloadApp prismlauncher)
  ];
}
