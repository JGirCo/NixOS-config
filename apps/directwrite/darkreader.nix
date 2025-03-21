{ pkgs, config, theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
  appconfig = with config.colorScheme.palette;
    with colors; ''
      {
      	    "schemeVersion": 2,
      	    "enabled": true,
      	    "fetchNews": true,
      	    "theme": {
      		"mode": 1,
      		"brightness": 100,
      		"contrast": 100,
      		"grayscale": 0,
      		"sepia": 0,
      		"useFont": false,
      		"fontFamily": "Open Sans",
      		"textStroke": 0,
      		"engine": "dynamicTheme",
      		"stylesheet": "",
      		"darkSchemeBackgroundColor": "#${base00}",
      		"darkSchemeTextColor": "#${base05}",
      		"lightSchemeBackgroundColor": "#${base05}",
      		"lightSchemeTextColor": "#${base00}",
      		"scrollbarColor": "auto",
      		"selectionColor": "auto",
      		"styleSystemControls": false,
      		"lightColorScheme": "Default",
      		"darkColorScheme": "Default",
      		"immediateModify": false
      	    },
      	    "presets": [],
      	    "customThemes": [],
      	    "enabledByDefault": true,
      	    "enabledFor": [],
      	    "disabledFor": [],
      	    "changeBrowserTheme": false,
      	    "syncSettings": false,
      	    "syncSitesFixes": true,
      	    "automation": {
      		"enabled": false,
      		"mode": "",
      		"behavior": "OnOff"
      	    },
      	    "time": {
      		"activation": "18:00",
      		"deactivation": "9:00"
      	    },
      	    "location": {
      		"latitude": null,
      		"longitude": null
      	    },
      	    "previewNewDesign": true,
      	    "enableForPDF": true,
      	    "enableForProtectedPages": true,
      	    "enableContextMenus": false,
      	    "detectDarkTheme": false,
      	    "displayedNews": [
      		"thanks-2023"
      	    ]
      	}
    '';
in {
  xdg = {
    configFile = {
      darkreader = {
        enable = true;
        target = "darkreader/config.json";
        text = appconfig;
      };
    };
  };
}
