{ nixpkgs,
  nixpkgs-darwin,
  systems ?
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ],
  nixpkgsOptions ? {},
  basepkgs,
  name,
  packages,
  sources ? {nixpack}: {},
  compiler ? "default",
  installHoogle ? false,
  installDocs ? false
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

  sources1 =
    basepkgs.nixpack.lib.mergeSources
      basepkgs.sources (sources {nixpack = basepkgs.nixpack;});
  mkEnv = system:
    let
      nixpkgs1 =
        if builtins.match ".*darwin.*" system != null
        then nixpkgs-darwin
        else nixpkgs;
      pkgs = import nixpkgs1 (nixpkgsOptions // { inherit system; });
      pkgs1 = pkgs.extend (self: super: {
        nixpack = basepkgs.nixpack;
      });
      env = import ./env.nix {
        nixpkgs = pkgs1;
        sources = sources1;
        inherit name;
        inherit packages;
        inherit compiler;
        inherit installHoogle;
        inherit installDocs;
      };
    in env;

in {
  devShells = forAllSystems (system: { default = (mkEnv system).shell; });
  packages = forAllSystems (system: (mkEnv system).nixpkgs.haskellPackages);
  nixpkgs = forAllSystems (system: (mkEnv system).nixpkgs);
  nixpack = basepkgs.nixpack;
  sources = sources1;
}
