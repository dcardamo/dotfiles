{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Install language servers and tools
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # HTML/CSS/JSON
      nodePackages.bash-language-server
      python3Packages.python-lsp-server
      rust-analyzer
      taplo # TOML LSP
      yaml-language-server

      # Formatters and linters
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      black
      rustfmt
      shfmt

      # Tools
      ripgrep
      fd
      tree-sitter
      gcc # For treesitter compilation
    ];

    # Neovim plugins managed by Nix
    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim

      # Dependencies
      plenary-nvim
      nvim-web-devicons
      nui-nvim

      # UI
      tokyonight-nvim
      lualine-nvim
      bufferline-nvim
      neo-tree-nvim
      which-key-nvim

      # Editor enhancements
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-autopairs
      nvim-surround
      undotree
      trouble-nvim
      flash-nvim

      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets

      # Git
      gitsigns-nvim
      diffview-nvim
      neogit
      git-blame-nvim
      git-conflict-nvim

      # Telescope
      telescope-nvim
      telescope-fzf-native-nvim

      # Session & Project
      persistence-nvim
      project-nvim

      # AI Integration
      avante-nvim
    ];
  };

  # Create the Lua configuration structure
  xdg.configFile = {
    "nvim/init.lua".source = ./neovim/init.lua;
    "nvim/lua/config/options.lua".source = ./neovim/lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source = ./neovim/lua/config/keymaps.lua;
    "nvim/lua/config/lazy.lua".source = ./neovim/lua/config/lazy.lua;
    "nvim/lua/plugins/ui.lua".source = ./neovim/lua/plugins/ui.lua;
    "nvim/lua/plugins/editor.lua".source = ./neovim/lua/plugins/editor.lua;
    "nvim/lua/plugins/lsp.lua".source = ./neovim/lua/plugins/lsp.lua;
    "nvim/lua/plugins/git.lua".source = ./neovim/lua/plugins/git.lua;
    "nvim/lua/plugins/telescope.lua".source = ./neovim/lua/plugins/telescope.lua;
    "nvim/lua/plugins/ai.lua".source = ./neovim/lua/plugins/ai.lua;
  };

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Add shell aliases
  programs.zsh.shellAliases = {
    e = "nvim";
    vi = "nvim";
    vim = "nvim";
  };

  # Configure git to use nvim
  programs.git.extraConfig = {
    core.editor = "nvim";
    sequence.editor = "nvim";
  };
}
