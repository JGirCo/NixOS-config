{ config, lib, pkgs, theme, font, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors; {
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      allow_images = true;
      # allow_markup=true;
      term = "kitty";
      matching = "contains";
      width = 400;
      height = 300;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      location = "top";
      layer = "overlay";
      hide_scroll = true;
      insensitive = true;
      no_actions = true;
      columns = 1;
      dynamic_lines = true;
      image_size = 24;
      line_wrap = "char";
      prompt = "";
      normal_window = true;
    };

    style = ''
      window {
      margin: 5px;
      padding: 20px;
      border: 4px solid #${focused};
      border-radius: 20px;
      background-image: url('/home/jgirco/Pictures/wallpapers/${theme}.jpg');
      background-size: cover; /* This will make the image cover the entire box */
      background-repeat: no-repeat; /* This will prevent the image from repeating */
      background-position: center; /* This will center the image within the box */
      }

      #input {
      margin: 15px;
      padding: 4px;
      border: 2px solid #${focused};
      background-color: #${base};
      color: #${text2};
      }

      #inner-box {
      margin: 5px;
      border: 0px solid yellow;
      background-color: transparent;
      border-radius: 10px;
      }

      #outer-box {
      margin: 20px;
      # padding: 10px;
      # border: 8px solid #${focused};
      # background-color: #${base};
      border-radius: 20px;
      }

      #scroll {
      margin: 0px;
      border: 0px solid #${focused};
      background-color: #${base};
      border-radius: 10px;
      }

      #text {
      margin: 5px;
      border: 0px solid cyan;
      background-color: transparent;
      color: #${base};
      }

      #entry:selected {
      background-color: #${focused};
      }
      #entry {
      margin: 5px;
      background-color: #${inactive};
      border-radius: 10px;
      }
    '';
  };
}
