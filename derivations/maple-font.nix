{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "maple-font";

  src = pkgs.fetchurl {
    # url =
    #   "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta29/MapleMono-TTF-AutoHint.zip";
    # sha256 = "0ma6nah21zvywbsya9biaa84wz0z6nvqs8ckmwj6abl9pifz9k20";

    # v7.0 Comes with the Nerd Font Glyphs at double width by default
    url =
      "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta29/MapleMono-NF.zip";
    sha256 = "0rkv7r19yvzn2ns6fd1am9j9xhs69sa7fpxv582qkmydp8v4899x";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    ${pkgs.unzip}/bin/unzip $src -d $out/share/fonts/truetype
  '';
  # All of this was wholly unnecesary :D

  # installPhase = ''
  #   mkdir -p $out/share/fonts/truetype
  #   ${pkgs.unzip}/bin/unzip $src -d .
  #   for file in ./*.ttf; do
  #     ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher --mono --complete --out $out/share/fonts/truetype "$file"
  #   done
  # '';
}
