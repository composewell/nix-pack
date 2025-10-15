# README

This repository provides pure nix code to manage bundles of packages using nix
in a modular way. You can use a pure `default.nix`, `shell.nix` file to use it
or if you prefer flakes you can use a `flake.nix`.

## Specifying Layered Package Sets

If you want to bundle all your projects in one place and build them
consistently as a set with a single build command or make them
all available in a nix shell -- you can conveniently specify such
an environment using `nix-pack`. You can specify different layers
overriding each other -- e.g. if you want packages from hackage only,
or if you want hackge + overrides from your github repos, or you want
hackage + github + your local repositories -- all these use cases are
conveniently supported with easy selection of layers you want.

See the `flake.bundle.nix` or `default.bundle.nix` files for an example usage.

Copy and edit the above file and add the sources of your packages
(github repositories or hackage locations) in `sources.nix` and the list
of packages that you want to select as the nix environment or nix shell
in the `packages.nix` file.

### Building an Individual Package

Example:
```
nix build "git+ssh://git@github.com/composewell/nix-pack.git#streamly"
```

## Override the Master set in a project

Assuming you are maintianing a master package set as described above
you may now want to use that set or a subset of it and maybe with some
overrides as dependencies in individual projects. That use case is also
conveniently supported. You can merge sources of the master set and
sources of your project repo to create a overridden source set and use
that to create a nix shell.

### Example `flake.nix` for dev projects

Copy the `flake.dev.nix` file in the project repo, update the
nix-pack repo revision in it and add a `sources.nix` and
`packages.nix` file.

A sample `packages.nix`:

```
{ nixpkgs }:
{
dev-packages = with nixpkgs.haskellPackages; [ streamly ];
}
```

A sample `sources.nix`. Be careful to spell a name you are overriding from
nix-pack correctly, if the name is different the override wll not
occur and you will be using the version from nix-pack unknowingly:

```
{defenv}:
with defenv.sources;
{
layers = [ { streamly = local ./.; } ];
}
```

## Finding Outdated Revisions in `sources.nix`

If any of the sources have been updated upstream you can find if the
sources in your bundle or project are stale and eed to be updated.

Use the `(nix-pack/nix).listSources` function to create a manifest of sources
and use `nix-pack/bin/outdated.sh` on the result to find the stale sources.

For example, you can do that by running these commands from the repo root:
```
nix-build -E '
  let
    nixpackSrc = builtins.fetchTarball "https://github.com/composewell/nix-pack/archive/b3db598aa.tar.gz";
    nixpack = import (nixpackSrc + "/nix");
  in nixpack.listSources { sources = ./sources.nix; }
'
bin/outdated.sh ./result
```
