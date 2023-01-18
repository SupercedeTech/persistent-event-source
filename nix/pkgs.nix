import ./pin.nix {
  config = {

    packageOverrides = pkgs: {
        haskell = pkgs.lib.recursiveUpdate pkgs.haskell {
        packageOverrides = hpNew: hpOld: {
            persistent-event-source = hpNew.callPackage ../default.nix {};
            };
        };
    };
  };
}
