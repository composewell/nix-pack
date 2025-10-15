{ sources }:
let
  nixpack = import ./default.nix;
  pkgs = import <nixpkgs> {};
  srcs = import sources { inherit nixpack; };

  # merge layer sets if they exist
  packages = pkgs.lib.attrsets.mergeAttrsList [
    (pkgs.lib.optionalAttrs (srcs ? layer1) srcs.layer1)
    (pkgs.lib.optionalAttrs (srcs ? layer2) srcs.layer2)
    (pkgs.lib.optionalAttrs (srcs ? layer3) srcs.layer3)
    (pkgs.lib.optionalAttrs (srcs ? other)  srcs.other)
  ];

  text = builtins.concatStringsSep "\n"
  (builtins.filter (s: s != "")
    (pkgs.lib.mapAttrsToList
      (name: spec:
        if spec.type == "github" then
          "${name},${spec.owner},${spec.repo},${spec.branch},${spec.rev}"
        else ""
      )
      packages));
in
pkgs.stdenv.mkDerivation {
  name = "list-sources";
  buildCommand = ''
    echo "Generating list of all github sources..."
    echo "${text}" > $out
    echo "Generated: $out"
  '';
}
