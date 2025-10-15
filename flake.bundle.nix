{
  description = "Nix Haskell Development Environment";

  # XXX it downloads both of these on both systems.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/branch-off-24.11";
    #nixpkgs.url = "github:NixOS/nixpkgs/b2a3852bd078e68dd2b3dfa8c00c67af1f0a7d20"; # nixpkgs-25.05
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/c3d456aad3a84fcd76b4bebf8b48be169fc45c31"; # nixpkgs-25.05-darwin
    #nix-pack.url = "path:.";
    nix-pack.url = "github:composewell/nix-pack/b3db598aa29533646b13a94aca3fee8ead622d06";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nix-pack }:
    let nixpack = import "${nix-pack}/nix";
    in nixpack.flakeOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      nixpkgsOptions = {
            config.allowUnfree = true;
            config.allowBroken = true;
          };
      envOptions = {
            name = "nixpack-flake";
            sources = import ./sources.nix {inherit nixpack;};
            packages = import ./packages.nix;
            compiler = "ghc96";
            hoogle = false;
            isDev = true;
      };
    } // { inherit nixpack;} ;
}
