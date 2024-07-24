{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "whichpr";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "itkq";
    repo = "whichpr";
    rev = "master";
    sha256 = "EA0+w05Ks2O23wEbdVxs3ICv7hrQrkRnCXyykZkazRg=";
  };

  buildInputs = [ pkgs.go ];

  buildPhase = ''
    export GOCACHE=$(mktemp -d)
    export GOMODCACHE=$(mktemp -d)
    go build -o whichpr .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp whichpr $out/bin/
  '';

  meta = {
    description = "Find the pull request from commit hash.";
    homepage = "https://github.com/itkq/whichpr";
    license = pkgs.lib.licenses.asl20;
  };
}
