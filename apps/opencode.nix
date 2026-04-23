{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;

    settings = {
      "$schema" = "https://opencode.ai/config.json";
      model = "ollama/qwen3.5:9b";

      provider = {
        ollama = {
          name = "Ollama";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://127.0.0.1:11434/v1";
          };
          models = {
            "qwen3.5:9b" = {
              "_launch" = true;
              name = "qwen3.5:9b";
            };
          };
        };

        openai = {
          options = {
            apiKey = "ollama";
            baseURL = "http://127.0.0.1:11434/v1";
          };
        };
      };
    };
  };
}
