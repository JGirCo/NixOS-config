{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;

    settings = {
      model = "local/qwen3.5-9b";

      providers.local = {
        api_base = "http://localhost:11434/v1";
        api_key = "ollama";
        models = {
          "qwen3.5-9b" = "qwen3.5:9b";
        };
      };

      options = {
        context_window = 32768;
        temperature = 0.2;
      };

      formatter.nixfmt = {
        disabled = false;
        command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
        extensions = [ ".nix" ];
      };

    };
  };
}
