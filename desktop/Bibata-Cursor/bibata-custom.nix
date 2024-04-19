{ pkgs, theme, ... }:
let
  colorScheme = import ../../colors.nix;
  nodeDependencies = (pkgs.callPackage ./default.nix { }).nodeDependencies;
in with colorScheme.${theme};
pkgs.stdenv.mkDerivation {
  name = "bibata-custom-${theme}";

  src = pkgs.fetchurl {
    url =
      "https://github.com/ful1e5/Bibata_Cursor/archive/refs/tags/v2.0.6.tar.gz";
    sha256 = "069b1yv191r7b8zl4vv1q0ljz6zizin71lv3g7wz3zn295m5s2d3";
  };

  dontUnpack = true;
  buildInputs = [ pkgs.nodejs pkgs.clickgen ];

  buildPhase = ''
    mkdir -p $out
    tar -xf $src -C $out
    cd $out/Bibata_Cursor-2.0.6
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"
    ${pkgs.nodejs}/bin/npx cbmp -d 'svg/modern' -o 'bitmaps/${theme}' -oc '${base}' -oc '${alt}' --loglevel=verbose
    ${pkgs.clickgen}/bin/ctgen build.toml -d 'bitmaps/${theme}' -n 'Bibata-${theme}' -c 'cursor for the ${theme} theme'
  '';

  installPhase = ''
    echo "Current OUT directory: $out"
    echo "Theme being used: ${theme}"
    ls -la "$out/Bibata_Cursor-2.0.6/themes/"
    mv "$out/Bibata_Cursor-2.0.6/themes/Bibata-${theme}" "$out/"
  '';
}
