{ lib, inputs, ... }:

# based on
# https://github.com/nix-community/home-manager/blob/fcac3d6d88302a5e64f6cb8014ac785e08874c8d/modules/programs/floorp.nix#L9

with lib;

let

  modulePath = [ "programs" "zen-browser" ];

  mkFirefoxModule = import (builtins.toPath (inputs.home-manager.outPath + "/modules/programs/firefox/mkFirefoxModule.nix"));

in {
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "Zen Browser";
      #wrappedPackageName = "floorp";
      #unwrappedPackageName = "floorp-unwrapped";
      visible = true;

      platforms.linux = { configPath = ".zen"; };
      #platforms.darwin = { configPath = "Library/Application Support/Floorp"; };
    })
  ];
}