{ config, lib, pkgs, theme, font, ... }:

let colorScheme = import ../colors.nix;
in with colorScheme."${theme}"; {
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      allow_images = true;
      # allow_markup=true;
      term = "wezterm";
      matching = "contains";
      width = 400;
      height = 300;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      location = "top";
      layer = "overlay";
      hide_scroll = false;
      insensitive = true;
      no_actions = true;
      columns = 1;
      dynamic_lines = true;
      image_size = 24;
      line_wrap = "char";
      prompt = "";
    };

    style = ''
      window {
      margin: 5px;
      border: 2px solid ${focused};
      border-radius: 20px;
      background-image: url('/home/juanma/Pictures/wallpapers/${theme}.jpg');
      background-size: cover; /* This will make the image cover the entire box */
      background-repeat: no-repeat; /* This will prevent the image from repeating */
      background-position: center; /* This will center the image within the box */
      }

      #input {
      margin: 5px;
      border: 2px solid ${focused};
      background-color: ${base};
      color: ${text2};
      }

      #inner-box {
      margin: 5px;
      border: 0px solid yellow;
      background-color: transparent;
      border-radius: 10px;
      }

      #outer-box {
      margin: 20px;
      padding: 10px;
      border: 2px solid ${focused};
      background-color: ${base};
      border-radius: 20px;
      border-radius: 10px;
      }

      #scroll {
      margin: 0px;
      border: 0px solid ${focused};
      background-color: ${base};
      border-radius: 10px;
      }

      #text {
      margin: 5px;
      border: 0px solid cyan;
      background-color: transparent;
      color: ${base};
      }

      #entry:selected {
      background-color: ${focused};
      }
      #entry {
      margin: 5px;
      background-color: ${inactive};
      border-radius: 10px;
      }
    '';
  };
}
