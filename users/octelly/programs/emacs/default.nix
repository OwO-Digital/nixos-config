{ pkgs, ... }:
let
  package = (pkgs.emacsWithPackagesFromUsePackage {
    config = ./config.el;
    defaultInitFile = true;
    package = pkgs.emacs-pgtk;
  });
in
{
  programs.emacs = {
    inherit package;

    enable = true;
  };
  service.emacs = {
    inherit package;
  };
}
