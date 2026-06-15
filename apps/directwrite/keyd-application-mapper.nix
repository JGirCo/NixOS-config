let
  appconfig = ''
    [zen-twilight]
    alt.k = C-S-tab
    alt.j = C-tab

    [firefox*]

    alt.k = C-S-tab
    alt.j = C-tab
    alt.h = A-left
    alt.l = A-right

    [with-you-x86-64]

    enter = rightshift

    [|undertale]

    w = up
    a = left
    s = down
    d = right
  '';
in
{
  xdg = {
    configFile = {
      keyd = {
        enable = true;
        target = "keyd/app.conf";
        text = appconfig;
      };
    };
  };
}

# alt.h = C-S-tab
# alt.l = C-tab
# alt.k = A-left
# alt.j = A-right
