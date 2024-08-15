{
  programs.nixvim.autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Remove trailing whitespace on save
    {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Set indentation to 2 spaces for nix files
    {
      event = "FileType";
      pattern = "nix";
      command = "setlocal tabstop=2 shiftwidth=2";
    }
    # Set indentation to 2 spaces for ino files
    {
      event = "FileType";
      pattern = "ino";
      command = "setlocal tabstop=2 shiftwidth=2";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [ "tex" "latex" "markdown" "norg" ];
      command = "setlocal spell spelllang=en,es";
    }
    {
      event = "FileType";
      pattern = "norg";
      command = "setlocal norelativenumber colorcolumn=0 conceallevel=2";
    }
  ];
}
