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
      rev = "e56313946fdfe77eed91c54d791b7be8aa73c495";
      sha256 = "0a2nnk9ifaln0v9dq0wgdazqxika0j32vv8p6s4qsrpfs2kxaqar";
    };
  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: {
      exitcode = import sources.exitcode { inherit nixpkgs compiler; };
    };
  };

  bomradar = modifiedHaskellPackages.callPackage ./bomradar.nix {};

in

  bomradar

