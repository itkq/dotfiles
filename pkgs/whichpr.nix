{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "aqua";
  src = pkgs.fetchurl {
    # XXX: darwin arm64 not distributed
    url = if pkgs.stdenv.isDarwin then "https://github.com/pocke/whichpr/releases/download/v1.0.0/whichpr_1.0.0_darwin_amd64.tar.gz" else "https://github.com/pocke/whichpr/releases/download/v1.0.0/whichpr_1.0.0_linux_amd64.tar.gz";
    sha256 = if pkgs.stdenv.isDarwin then pkgs.lib.fakeSha256 else pkgs.lib.fakeSha256;
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -r whichpr $out/bin
  '';

  meta = {
    description = "Find the pull request from commit hash.";
    homepage = "https://github.com/pocke/whichpr";
    license = pkgs.lib.licenses.asl20;
  };
}
