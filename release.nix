{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
  facts = pkgs.callPackage ./derivation.nix {};
in {
  test = pkgs.runCommandNoCC "facts-test" {} ''
    mkdir -p $out
    : ${pkgs.facts}
  '';
}