{
  description = "uv2nix - Python Package Management with UV and Nix";

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
        pythonPackages = pkgs.python39Packages;

        # remove when uv version is updated to 0.3.0 on upstream
        uv = pythonPackages.buildPythonApplication rec {
          pname = "uv";
          version = "0.3.0";
          pyproject = true;

          src = pkgs.fetchFromGitHub {
            owner = "astral-sh";
            repo = "uv";
            rev = "refs/tags/${version}";
            hash = "sha256-5tX7PvON/n2ntwunoKU/U9zUIVxU+SPVWXelfHapqDA=";
          };

          cargoDeps = pkgs.rustPlatform.importCargoLock {
            lockFile = ./Cargo.lock;
            outputHashes = {
              "async_zip-0.0.17" = "sha256-3k9rc4yHWhqsCUJ17K55F8aQoCKdVamrWAn6IDWo3Ss=";
              "pubgrub-0.2.1" = "sha256-OVR4ioUSbraMZYglIGzBA0KQ+XZY0P0+fw68v8/e9sQ=";
              "reqwest-middleware-0.3.3" = "sha256-csQN7jZTifliSTsOm6YrjPVgsXBOfelY7LkHD1HkNGQ=";
            };
          };

          nativeBuildInputs = [
            pkgs.cmake
            pkgs.installShellFiles
            pkgs.pkg-config
            pkgs.rustPlatform.cargoSetupHook
            pkgs.rustPlatform.maturinBuildHook
          ];

          buildInputs = [
            pkgs.libiconv
            pkgs.libxcrypt
          ];

          dontUseCmakeConfigure = true;

          cargoBuildFlags = [
            "--package"
            "uv"
          ];

          postInstall = ''
            export HOME=$TMPDIR
            installShellCompletion --cmd uv \
              --bash <($out/bin/uv --generate-shell-completion bash) \
              --fish <($out/bin/uv --generate-shell-completion fish) \
              --zsh <($out/bin/uv --generate-shell-completion zsh)
          '';

          pythonImportsCheck = ["uv"];
        };
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # allow unfree packages, i.e. cuda packages
        };

        devShells.default = pkgs.mkShell {
          name = "devshell";
          venvDir = "./.venv";
          buildInputs = [
            pythonPackages.python # python interpreter
            pythonPackages.venvShellHook # venv hook for creating/activating
            uv
          ];

          # Run only after creating the virtual environment
          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
          '';

          # Run on each venv activation.
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
          '';
        };
      };
    };
}
