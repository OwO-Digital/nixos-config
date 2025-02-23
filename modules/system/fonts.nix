{ config, pkgs, lib, ... }:

with builtins;
with lib;
let
  fontList = unique (flatten
    (mapAttrsToList
      (n: v: v.fc.fonts)
      config.modules.users));

  nerdFontList = unique (flatten
    (mapAttrsToList
      (n: v: v.fc.nerd-fonts)
      config.modules.users));
in
{
  config.fonts.packages = fontList ++ (attrsets.attrVals nerdFontList pkgs.nerd-fonts);
}
