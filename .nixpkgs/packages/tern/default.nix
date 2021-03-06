{ recurseIntoAttrs, callPackage, nodejs }:

let
  self = recurseIntoAttrs (
    callPackage <nixpkgs/pkgs/top-level/node-packages.nix> {
      inherit nodejs self;
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {
        "tern" = { passthru.nodePackages = self; };
      };
    });
in self.tern
