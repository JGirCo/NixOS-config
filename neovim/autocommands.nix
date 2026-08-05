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

    # {
    #   event = "FileType";
    #   pattern = "[norg, typ]";
    #   command = "setlocal norelativenumber nonumber colorcolumn=0 conceallevel=2";
    # }
  ];
}
