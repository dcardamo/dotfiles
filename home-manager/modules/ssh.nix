{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "venus" = {
        hostname = "10.0.0.9";
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
