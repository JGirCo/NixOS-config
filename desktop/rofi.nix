{ config, lib, pkgs, theme, font, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors; {
    programs.rofi = {
      enable = true;
      theme = ''
/**
 *
 * Author : Aditya Shakya (adi1090x)
 * Github : @adi1090x
 *
 * Rofi Theme File
 * Rofi Version: 1.7.3
 **/

/*****----- Configuration -----*****/
configuration {
	modi:                       "drun";
    show-icons:                 true;
    display-drun:               "";
    display-run:                "";
    display-filebrowser:        "";
    display-window:             "";
	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
	window-format:              "{w}   {c}   {t}";
}

/*****----- Global Properties -----*****/
* {
    font:                        "Iosevka Nerd Font 10";
}

/*****----- Main Window -----*****/
window {
    /* properties for window widget */
    transparency:                "real";
    location:                    center;
    anchor:                      center;
    fullscreen:                  false;
    width:                       800px;
    x-offset:                    0px;
    y-offset:                    0px;

    /* properties for all widgets */
    enabled:                     true;
    margin:                      0px;
    padding:                     0px;
    border-radius:               20px;
    cursor:                      "default";
    background-color:            #162022;
    background-image:            url("~/Pictures/wallpapers/rose-pine.jpg", width);
}

/*****----- Main Box -----*****/
mainbox {
    enabled:                     true;
    spacing:                     20px;
    padding:                     40px;
    background-color:            transparent;
    children:                    [ "inputbar", "listview" ];
}

/*****----- Inputbar -----*****/
inputbar {
    enabled:                     true;
    spacing:                     0px;
    margin:                      0px 200px 0px 0px;
    padding:                     25px;
    border:                      2px;
    border-radius:               20px;
    border-color:                white;
    background-image:            url("~/Pictures/wallpapers/rose-pine-dawn.jpg", none);
    children:                    [ "textbox-prompt-colon", "entry" ];
}

textbox-prompt-colon {
    enabled:                     true;
    expand:                      false;
    padding:                     8px 11px;
    border-radius:               8px;
    background-color:            white;
    text-color:                  black;
    str:                         "";
}
entry {
    enabled:                     true;
    padding:                     8px 12px;
    border:                      0px;
    background-color:            transparent;
    text-color:                  white;
    cursor:                      text;
    placeholder:                 "Search...";
    placeholder-color:           inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}

/*****----- Listview -----*****/
listview {
    enabled:                     true;
    columns:                     1;
    lines:                       8;
    cycle:                       true;
    dynamic:                     true;
    scrollbar:                   false;
    layout:                      vertical;
    reverse:                     false;
    fixed-height:                true;
    fixed-columns:               true;

    spacing:                     10px;
    margin:                      0px 200px 0px 0px;
    padding:                     10px;
    border:                      2px;
    border-radius:               20px;
    border-color:                white;
    background-image:            url("~/Pictures/wallpapers/tokyo-night-moon.jpg", width);
    cursor:                      "default";
}

/*****----- Elements -----*****/
element {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     5px 10px;
    border:                      0px;
    border-radius:               18px;
    border-color:                white;
    background-color:            transparent;
    text-color:                  #162022;
    cursor:                      pointer;
}
element selected.normal {
    background-color:            #162022;
    text-color:                  white;
}
element-icon {
    background-color:            transparent;
    size:                        32px;
    cursor:                      inherit;
}
element-text {
    background-color:            inherit;
    text-color:                  inherit;
    cursor:                      inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}

/*****----- Message -----*****/
error-message {
    padding:                     20px;
    background-color:            transparent;
    text-color:                  white;
}
message {
    padding:                     0px;
    background-color:            inherit;
    text-color:                  #FF9030;
}
textbox {
    padding:                     0px;
    border-radius:               0px;
    background-color:            inherit;
    text-color:                  inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}
      '';
    };
  }
