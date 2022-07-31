let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };

  basePackages = [
    pkgs.nodePackages.purty
    pkgs.nixfmt
    pkgs.nodejs-16_x
    pkgs.yarn
  ];

  inputs = basePackages;

  hooks = ''
  '';
in pkgs.mkShell {
  buildInputs = inputs;
  shellHook = hooks;
}
