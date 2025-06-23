{pkgs, ...}: {
  home.packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    
    # Additional Rust development tools
    cargo-edit
    cargo-watch
    cargo-expand
    cargo-outdated
    cargo-audit
    cargo-nextest
    
    # For C dependencies when building Rust projects
    pkg-config
    openssl
    
    # Debugging tools
    lldb
    gdb
  ];
  
  # Rust environment variables
  home.sessionVariables = {
    RUST_BACKTRACE = "1";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}