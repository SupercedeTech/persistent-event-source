import ./pin.nix {
  config = {

    packageOverrides = pkgs: {
        haskell = pkgs.lib.recursiveUpdate pkgs.haskell {
        packageOverrides = hpNew: hpOld: {
            esqueleto-mtl = hpNew.callCabal2nix "esqueleto-mtl"
              (pkgs.fetchFromGitHub {
                owner = "SupercedeTech";
                repo = "esqueleto-mtl";
                rev = "9831b94c1f71835811fd736bcc62f18e996f76bb";
                sha256 = "sha256-6FYR83iAxNoF5i7FILilKd8vvx8dWm0+rXc6GMfe6cI=";
              })
              {};

            persistent-eventsource = hpNew.callPackage ../default.nix {};
            };
        };
    };
  };
}
