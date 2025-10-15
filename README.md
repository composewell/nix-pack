# README

## Building a specific package

Example:
```
nix build "git+ssh://git@github.com/composewell/nix-pack.git#streamly"
```

## Example `flake.nix` for sub projects

Copy the `flake.nix.sample` file in the project repo, update the
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

## Finding outdated commits in sources.nix

Run these commands from the repo root:
```
nix-build -E  '(import ./nix).listSources {sources = ./sources.nix;}'
bin/outdated.sh ./result
```
