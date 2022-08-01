let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };

  basePackages = [
    pkgs.purescript
    pkgs.spago
    pkgs.nodePackages.pscid
    pkgs.nodePackages.purescript-psa
    pkgs.nodePackages.purty
    pkgs.nixfmt
    pkgs.nodejs-16_x
    pkgs.yarn
  ];

  inputs = basePackages;

  hooks = "";
in pkgs.mkShell {
  buildInputs = inputs;
  shellHook = hooks;
}
