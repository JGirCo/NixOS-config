{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        spec = [
          {
            mode = [ "n" ];
            key = "<leader>x";
            icon = "";
            name = "Trouble";
          }
          {
            mode = [ "n" ];
            key = "<leader>p";
            icon = "";
            name = "Preview";
          }
          {
            mode = [ "n" ];
            key = "<leader>gh";
            icon = "";
            name = "Git";
          }
        ];
      };
    };
  };
}
