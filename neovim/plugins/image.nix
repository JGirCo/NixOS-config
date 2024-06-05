{ pkgs, ... }: {
  programs.nixvim = {
    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = [ pkgs.imagemagick ];
    plugins.image = {
      enable = true;
      backend = "kitty";
    };
  };
}
