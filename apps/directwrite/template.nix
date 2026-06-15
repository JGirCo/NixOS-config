{
  pkgs,
  config,
  theme,
  lib,
  ...
}:
let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
  appconfig = with config.colorScheme.palette; with colors; "\n";
in
{
  home.file."$XDG_CONFIG_HOME/app/app.conf".text = appconfig;
}
