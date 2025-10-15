{
  description = "Dev project";

  # Replace "nix-pack" with your master package set
  inputs = {
    nix-pack.url = "github:composewell/nix-pack/b3db598aa29533646b13a94aca3fee8ead622d06";
    nixpkgs.follows = "nix-pack/nixpkgs";
    nixpkgs-darwin.follows = "nix-pack/nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nix-pack }:
    let
      nixpack = nix-pack.nixpack;
      src1 = import "${nix-pack}/sources.nix" { inherit nixpack; };
      src2 = import ./sources.nix {inherit nixpack;};
    in nixpack.flakeOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      nixpkgsOptions = {
            config.allowUnfree = true;
            config.allowBroken = true;
          };
      envOptions = {
            name = "my-project";
            sources = nixpack.lib.mergeSources src1 src2;
            packages = import ./packages.nix;
            compiler = "ghc96";
            hoogle = false;
            isDev = true;
      };
    };
}
