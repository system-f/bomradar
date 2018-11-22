{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  sources = {
    exitcode = (pkgs.fetchFromGitHub {
      owner = "qfpl";
      repo = "exitcode";
      rev = "28f57c842c8864542fde0efae8788ce7c2523fea";
      sha256 = "1v7aski1vvxxskg20xlgvgfvxv2yjyvdl3aszvvw0g6ak2jwgwsf";
    });
  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: {
      exitcode = import sources.exitcode { inherit nixpkgs compiler; };
    };
  };

  bomradar = modifiedHaskellPackages.callPackage ./bomradar.nix {};

in

  bomradar

