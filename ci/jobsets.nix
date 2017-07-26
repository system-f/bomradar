{ nixpkgs, declInput }: let pkgs = import nixpkgs {}; in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toXML declInput}
    EOF
    cat > $out <<EOF
    {
        "bomradar": {
            "enabled": 1,
            "hidden": false,
            "description": "bomradar",
            "nixexprinput": "bomradar",
            "nixexprpath": "release.nix",
            "checkinterval": 300,
            "schedulingshares": 1,
            "enableemail": false,
            "emailoverride": "",
            "keepnr": 5,
            "inputs": {
                "bomradar": { "type": "git", "value": "https://github.com/qfpl/bomradar", "emailresponsible": false },
                "nixpkgs": { "type": "git", "value": "https://github.com/NixOS/nixpkgs.git release-17.03", "emailresponsible": false }
            }
        }
    }
    EOF
  '';
}
