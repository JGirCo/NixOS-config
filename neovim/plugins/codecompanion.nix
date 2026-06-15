{
  programs.nixvim.plugins.codecompanion = {
    enable = true;
    settings = {
      adapters = {
        gemini = {
          __raw = ''
            function()
              return require("codecompanion.adapters").extend("gemini", {
                defaults = {
                  auth_method = "gemini-api-key",
                },
                env = {
                }
              })
            end
          '';
        };
        strategies = {
          agent = {
            adapter = "gemini";
          };
          chat = {
            adapter = "gemini";
          };
          inline = {
            adapter = "gemini";
          };
        };
      };
    };

  };
}
