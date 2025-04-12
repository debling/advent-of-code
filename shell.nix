{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [ (haskellPackages.ghcWithPackages (ps: with ps; [ split ])) ];
}
