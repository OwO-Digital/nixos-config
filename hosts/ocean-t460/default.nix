{ inputs, lib, repoConf, ... }:

let system = "x86_64-linux"; in
lib.nixosSystem {
  inherit system;

  modules = [
    {
      nixpkgs = repoConf;
      networking.hostName = "ocean-t460";
    }

    inputs.home.nixosModules.home-manager
    #inputs.flatpaks.nixosModules.declarative-flatpak
    inputs.determinate.nixosModules.default

    inputs.nixHW.nixosModules.lenovo-thinkpad-t460

    ../shared/configuration.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ] ++
  (lib.mapModulesRec' ../../modules import);

  specialArgs = { inherit inputs system; };
}
