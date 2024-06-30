# based on https://github.com/civitaspo/dotfiles/blob/a38466931f1864fac9bedf5d0b473cd9d0c97b39/home/lib/xdg.nix

{ ... }:

let
  xdgDir = ../xdg;
in
  with builtins;
  foldl' (acc: path: acc // (
    {
      configFile = (acc.configFile //
        {
          ${path} = {
            source = xdgDir + ("/" + path);
            recursive = true;
          };
        }
      );
    }))
    { enable = true; configFile = {}; }
    (filter (n: (match ".*" n) != null)
      (attrNames (readDir xdgDir)))
