{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "grub-theme-graphite";

  src = pkgs.fetchurl {
    url = "https://github.com/vinceliuice/Graphite-gtk-theme/archive/refs/heads/main.tar.gz";
    sha256 = "f9b30372cb0f4c2dbbb167c726f1bec8c924b515449ed2f3087df63b6c8a3f51";
  };

  installPhase = ''
    mkdir -p $out/icons
    for f in other/grub2/common/*; do
      [ -e "$f" ] || continue
      cp -r "$f" $out/
    done
    cp other/grub2/config/theme-1080p.txt $out/theme.txt
    cp other/grub2/backgrounds/1080p/wave-dark.png $out/background.png
    for f in other/grub2/assets/logos/1080p/*; do
      [ -e "$f" ] || continue
      cp -r "$f" $out/icons/
    done
    for f in other/grub2/assets/assets/1080p/*; do
      [ -e "$f" ] || continue
      cp -r "$f" $out/
    done
  '';
}
