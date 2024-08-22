{
  description = "uv2nix Rust CLI for working with uv.lock files";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux" # 64bit Intel/AMD Linux
        "x86_64-darwin" # 64bit Intel Darwin (macOS)
        "aarch64-linux" # 64bit ARM Linux
        "aarch64-darwin" # 64bit ARM Darwin (macOS)
      ];
      perSystem = {
        self',
        inputs',
        system,
        pkgs,
        config,
        ...
      }: let
        name = "uv2nix";
        version = self'.rev or "dirty";
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = name;
          inherit version;

          src = ./.;
          cargoSha256 = "";

          nativeBuildInputs = [
            pkgs.openssl.dev
            pkgs.pkg-config
          ];

          env = {
            PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
          };

          checkPhase = ''
            cargo test
          '';
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/uv2nix";
        };

        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [
              self'.packages.default
            ];

            # Add custom shell hooks
            postShellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
            '';
          };
        };
      };
    };
}
