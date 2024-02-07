let
  themes = import ./colors.nix;
  asf = "5";
in
with themes.rosepine; {
  z = "${base}";
  y = asf;
}
