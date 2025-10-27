{
  description = "Dev project";

  # Replace "nixpack" with your master package set
  inputs = {
    nixpack.url = "github:composewell/nixpack/b3db598aa29533646b13a94aca3fee8ead622d06";
    nixpkgs.follows = "nixpack/nixpkgs";
    nixpkgs-darwin.follows = "nixpack/nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nixpack }:
    let
      nixpack = nixpack.nixpack;
      src1 = import "${nixpack}/sources.nix" { inherit nixpack; };
      src2 = import ./sources.nix {inherit nixpack;};
    in nixpack.flakeOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      inherit nixpack;
      nixpkgsOptions = {
            config.allowUnfree = true;
            config.allowBroken = true;
          };
      envOptions = {
            name = "my-project";
            sources = nixpack.lib.mergeSources src1 src2;
            packages = import ./packages.nix;
            # Use default to utilize the cache,
            # specific compiler for reproducibility
            compiler = "default";
            hoogle = false;
            isDev = true;
      };
    };
}
