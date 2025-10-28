{
  description = "Dev project";

  # Replace "nixpack" with your super package set
  inputs = {
    basepkgs.url = "github:composewell/nixpack/b3db598aa29533646b13a94aca3fee8ead622d06";
    nixpkgs.follows = "basepkgs/nixpkgs";
    nixpkgs-darwin.follows = "basepkgs/nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, basepkgs }:
    let
      nixpack = basepkgs.nixpack;
      src1 = basepkgs.sources;
      src2 = import ./sources.nix {inherit nixpack;};
    in nixpack.mkOutputs {
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
