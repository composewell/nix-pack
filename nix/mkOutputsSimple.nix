{ name, path, nixpkgs, nixpkgs-darwin, basepkgs }:
let nixpack = basepkgs.nixpack;
    src1 = basepkgs.sources;
    src2 =
        with nixpack.mkSources;
        {
          layers = [
          {
            ${name} = local path;
          }
          ];
        };
    mypackages =
        { nixpkgs }:
        {
        dev-packages =
        [ nixpkgs.haskellPackages.${name}
        ];
        };
    in nixpack.mkOutputs {
      inherit nixpkgs;
      inherit nixpkgs-darwin;
      inherit nixpack;
      nixpkgsOptions = {
            config.allowUnfree = true;
            config.allowBroken = true;
          };
      envOptions = {
            name = "${name}-env";
            sources = nixpack.lib.mergeSources src1 src2;
            packages = mypackages;
            compiler = "default";
            hoogle = false;
            isDev = true;
      };
}
