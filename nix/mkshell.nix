# Copyright   : (c) 2022 Composewell Technologies
{ nixpkgs }:
let
  # XXX we should move this to packages.nix
  cocoa = if builtins.match ".*darwin.*" nixpkgs.system != null then
    [ nixpkgs.darwin.apple_sdk.frameworks.Cocoa ]
  else
    [ ];

  mkShell = hpkgs: pkgs: inputs: doHoogle: doBench:
    hpkgs.shellFor {
      packages = pkgs;
      # some dependencies of hoogle fail to build with quickcheck-2.14
      # We should use hoogle as external tool instead of building it here
      withHoogle = doHoogle;
      doBenchmark = doBench;
      # XXX On macOS cabal2nix does not seem to generate a dependency on
      # Cocoa framework.
      buildInputs = inputs ++ cocoa;
      # Use a better prompt
      shellHook = ''
        #CFG_DIR="$HOME/.config/streamly-packages"
        #CFG_FILE="$CFG_DIR/config.empty"
        #mkdir -p "$CFG_DIR"
        #export CABAL_DIR="$CFG_DIR"
        export CABAL_CONFIG=/dev/null
        #This is commented for hls to work with VSCode
        #cabal user-config update -a "jobs: 1"
        export PS1="$PS1(haskell) "
        #if test -n "$PS_SHELL"
        #then
        #  export PS1="$PS_SHELL\[$bldred\](nix:cw)\[$txtrst\] "
        #fi
      '';
    };

in mkShell
