{
  description = "prerequisites for nonempty";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python313;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            pyright
            uv
            direnv
            nix-direnv
            pre-commit
            entr
            gnumake

            # tox:
            python312
            python311
            python310
          ];
          # Use nix-ld when on NixOS, because ruff depends on libc:
          NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
            stdenv.cc.cc
          ];
          # Let uv use the python version of this flake by default:
          UV_PYTHON = pythonEnv.interpreter;
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}
