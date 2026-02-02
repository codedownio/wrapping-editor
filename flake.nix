{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.11";

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # overlays = [
          #   haskellNix.overlay
          #   # (import ./nix/fix-ghc-pkgs-overlay.nix)
          # ];
          # inherit (haskellNix) config;
        };
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
