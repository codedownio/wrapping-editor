{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gitignore = {
    url = "github:hercules-ci/gitignore.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";

  outputs = { self, flake-utils, gitignore, haskellNix, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            haskellNix.overlay
            # (import ./nix/fix-ghc-pkgs-overlay.nix)
          ];
          inherit (haskellNix) config;
        };

        src = gitignore.lib.gitignoreSource ./.;

        compilerNixName = "ghc9122";


      in
        {
          devShells = {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                gmp
                ncurses
                pcre
                pkg-config
                zlib

                pkgs.haskell.compiler.ghc9122
                pkgs.haskell.packages.ghc9122.cabal-install
                (pkgs.haskell-language-server.override { supportedGhcVersions = ["9122"]; })
              ];
            };
          };

          packages = {

          };
        }
    );
}
