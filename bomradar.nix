{ mkDerivation, base, checkers, lens, mtl, QuickCheck
, stdenv, tasty, tasty-hunit, tasty-quickcheck, transformers
}:
mkDerivation {
  pname = "bomradar";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base lens mtl transformers ];
  testHaskellDepends = [
    base checkers lens QuickCheck tasty tasty-hunit tasty-quickcheck
  ];
  homepage = "https://github.com/qfpl/bomradar";
  description = "BOM radar images";
  license = stdenv.lib.licenses.bsd3;
}
