{pkgs, ...}: {
  home.packages = with pkgs; [
    # Python formatters and linters
    pgformatter
    ruff
    
    # Python with packages
    (python3.withPackages
      (p: with p; [
        black
        flake8
        isort
        python-lsp-black
        python-lsp-server
      ]))
  ];
}