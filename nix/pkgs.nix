import ./pin.nix {
  config = {

    packageOverrides = pkgs: {
        haskell = pkgs.lib.recursiveUpdate pkgs.haskell {
        packageOverrides = hpNew: hpOld: {
            persistent-eventsource = hpNew.callPackage ../default.nix {};
            };
        };
    };
  };
}
