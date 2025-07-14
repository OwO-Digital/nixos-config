{ inputs, lib, repoConf, ... }:

let system = "x86_64-linux"; in
lib.nixosSystem {
  inherit system;

  modules = [
    {
      nixpkgs = repoConf;
      networking.hostName = "twinkpad";
    }

    inputs.home.nixosModules.home-manager
    inputs.nixHW.nixosModules.lenovo-thinkpad-t460s
    #inputs.flatpaks.nixosModules.declarative-flatpak
    #inputs.nixos-cosmic.nixosModules.default

    ../shared/configuration.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ] ++
  (lib.mapModulesRec' ../../modules import);

  specialArgs = { inherit inputs system; };
}
