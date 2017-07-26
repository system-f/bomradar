let
  pkgs = import <nixpkgs> {};

  bomradar = import ../default.nix;

  jobs = rec {
    inherit bomradar;
  };
in
  jobs
