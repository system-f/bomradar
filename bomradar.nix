{ mkDerivation, base, checkers, containers, directory, exitcode
, filepath, HTTP, lens, mtl, network-uri, process, QuickCheck
, stdenv, tasty, tasty-hunit, tasty-quickcheck, transformers
}:
mkDerivation {
  pname = "bomradar";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers directory exitcode filepath HTTP lens mtl
    network-uri process transformers
  ];
  executableHaskellDepends = [
    base containers directory exitcode filepath HTTP lens mtl
    network-uri process transformers
  ];
  testHaskellDepends = [
    base checkers lens QuickCheck tasty tasty-hunit tasty-quickcheck
  ];
  homepage = "https://github.com/qfpl/bomradar";
  description = "BOM weather radar";
  license = stdenv.lib.licenses.bsd3;
}
