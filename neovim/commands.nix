{
  programs.nixvim.userCommands = {
    CensorIP = {
      command = "%s/\\v\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/***.***.***.***/g";
      desc = "Censor IPv4 addresses in the current buffer";
    };
  };
}
