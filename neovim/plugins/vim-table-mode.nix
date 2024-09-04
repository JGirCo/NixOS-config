{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = [{
      plugin = pkgs.vimPlugins.vim-table-mode;
      config = ''
        let g:table_mode_motion_left_map = '<bar>h'
        let g:table_mode_motion_right_map = '<bar>l'
        let g:table_mode_motion_up_map = '<bar>k'
        let g:table_mode_motion_down_map = '<bar>j'
      '';
    }];
  };
}
