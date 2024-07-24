# based on https://github.com/izumin5210/dotfiles/blob/d9c5895326f03156944a463ff89177738db29902/pkgs/aqua.nix

{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "aqua";
  src = pkgs.fetchurl {
    url = if pkgs.stdenv.isDarwin then "https://github.com/aquaproj/aqua/releases/download/v2.27.0/aqua_darwin_arm64.tar.gz" else "https://github.com/aquaproj/aqua/releases/download/v2.27.0/aqua_linux_amd64.tar.gz";
    sha256 = if pkgs.stdenv.isDarwin then "sha256-z0UcCsSqi4Q7OhOyDENLLjD8dnfo4oKQcUx1Ny/q0qs=" else pkgs.lib.fakeSha256;
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -r aqua $out/bin
  '';

  meta = {
    description = "Declarative CLI Version manager written in Go. Support Lazy Install, Registry, and continuous update with Renovate. CLI version is switched seamlessly";
    homepage = "https://github.com/aquaproj/aqua";
    license = pkgs.lib.licenses.mit;
  };
}
