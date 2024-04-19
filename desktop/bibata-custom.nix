{ pkgs, theme, ... }:
let colorScheme = import ../colors.nix;
in with colorScheme.${theme};
pkgs.stdenv.mkDerivation {

  name = "bibata-custom";

  src = pkgs.fetchurl {
    url =
      "https://github.com/ful1e5/Bibata_Cursor/archive/refs/tags/v2.0.6.tar.gz";
    sha256 = "069b1yv191r7b8zl4vv1q0ljz6zizin71lv3g7wz3zn295m5s2d3";
  };

  dontUnpack = true;

  installPhase = ''
    tar -xf $src -C bibata
    mkdir bibata
    cd bibata
    cd Bibata_Cursor-2.0.6
    ls .
    ${pkgs.nodejs_21}/bin/npx cbmp -d 'svg/modern' -o 'bitmaps/${theme}' -oc '${base}' -oc '${alt}' --loglevel=verbose
    ${pkgs.clickgen}/bin/ctgen build.toml -d 'bitmaps/${theme}' -n 'Bibata-${theme}' -c 'cursor for the ${theme} theme'
    mv ./themes/Bibata-${theme} $out/
  '';
}
