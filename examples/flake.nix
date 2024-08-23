{
  description = "uv2nix - Example Python Package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    uv2nix.url = "github:mcanueste/uv2nix";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    uv2nix,
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

        packages = import ./packages.nix {inherit pkgs;};
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
            pkgs.uv
          ] ++ packages;

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
