{
  description = "Nix Haskell Development Environment";
  outputs = { self }:
    let nixpack = import ./nix;
    in {
      nixpack = nixpack;
      sources = {nixpack}: {};
    };
}
