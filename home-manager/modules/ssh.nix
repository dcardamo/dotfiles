{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "pluto" = {
        hostname = "10.0.0.5";
      };
      "arcee" = {
        hostname = "10.0.0.4";
      };
      "heatwave" = {
        hostname = "10.0.1.4";
      };
    };
  };
}
