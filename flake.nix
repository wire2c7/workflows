{
  description = "wire2c7/workflows";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      systems,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      systems = import systems;

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              rumdl-check.enable = true;
            };
          };

          # nix-ci.yaml を自身の CI でも使うため、利用側と同じツールを揃える
          devShells.default = pkgs.mkShellNoCC {
            packages = [
              config.treefmt.build.wrapper
              pkgs.actionlint
              pkgs.betterleaks
              pkgs.commitlint
              pkgs.prek
            ];

            shellHook = ''
              if [ -z "''${CI:-}" ] && git rev-parse --git-dir >/dev/null 2>&1; then
                prek install --quiet
              fi
            '';
          };
        };
    };
}
