{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  sources = {
    exitcode = pkgs.fetchFromGitHub {
      owner = "qfpl";
      repo = "exitcode";
      rev = "9ecee5b3a21a29a92aba9c1b9a73cdcb8ae20d32";
      sha256 = "0svjhvrl5rfqf7vddi8jb4k65jdv44m7vmm33f9nfhgjpcjc22pj";
    };
  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: {
      exitcode = super.callCabal2nix "exitcode" sources.exitcode {};
    };
  };

  bomradar = modifiedHaskellPackages.callPackage ./bomradar.nix {};

in

  bomradar

