{pkgs, ...}: {
  home.packages = with pkgs;
    [
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

      # Code coverage tools
      cargo-tarpaulin
      # cargo-llvm-cov # Temporarily disabled - broken package

      # For C dependencies when building Rust projects
      pkg-config
      openssl
      cmake
      lld

      # Additional build dependencies commonly needed
      openssl.dev
      zlib
      libiconv

      # Debugging tools
      lldb
      gdb
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin (
      with pkgs.darwin.apple_sdk; [
        frameworks.Security
        frameworks.SystemConfiguration
        frameworks.CoreServices
        frameworks.CoreFoundation
        pkgs.libiconv
      ]
    );

  # Rust environment variables
  home.sessionVariables = {
    RUST_BACKTRACE = "1";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.pkg-config}/lib/pkgconfig";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  };
}
