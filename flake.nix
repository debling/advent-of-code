{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        # arm systems
        "aarch64-darwin"
        "aarch64-linux"

        # x86
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forEachSystem = fn: nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        fn pkgs);
    in
    {
      devShell = forEachSystem (pkgs:
        with pkgs;
        mkShell {
          packages = [ guile guile-gcrypt ];
        }
      );

      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
    };
}
