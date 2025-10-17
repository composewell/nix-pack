{ nixpkgs,
  nixpkgs-darwin,
  nixpack,
  systems ?
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ],
  nixpkgsOptions ? {},
  envOptions
}:

let
  # TODO: remove darwin if nixpkgs-darwin is not specified
  # TODO: remove linux if nixpkgs is not specified

  # TODO: Move this as a lower level helper module
  forAllSystems = f:
    builtins.listToAttrs (map (system: {
      name = system;
      value = f system;
    }) systems);

  mkEnv = system:
    let
      nixpkgs1 =
        if builtins.match ".*darwin.*" system != null
        then nixpkgs-darwin
        else nixpkgs;
      pkgs = import nixpkgs1 (nixpkgsOptions // { inherit system; });
      pkgs1 = pkgs.extend (self: super: {
        nixpack = nixpack;
      });
      env = import ./env.nix ({
        compiler = "default";
        hoogle = false;
        isDev = false;
      } // envOptions // {nixpkgs = pkgs1;});
    in env;

in {
  devShells = forAllSystems (system: { default = (mkEnv system).shell; });
  # This provides a central repository of executables that we can build and
  # install. We can avoid having individual flake files across multiple
  # repositories.
  packages = forAllSystems (system: (mkEnv system).nixpkgs.haskellPackages);
  nixpkgs = forAllSystems (system: (mkEnv system).nixpkgs);
}
