{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = [ pkgs.imagemagick ];
    plugins.image = {
      enable = true;
      settings.integrations = { markdown.enabled = true; };
      settings.hijack_file_patterns =
        [ "*.png" "*.jpg" "*.jpeg" "*.gif" "*.webp" "*.svg" ];
    };
  };
}
