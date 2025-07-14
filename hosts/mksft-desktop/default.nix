{ inputs, lib, repoConf, ... }:

let system = "x86_64-linux"; in
lib.nixosSystem {
  inherit system;

  modules = [
    {
      nixpkgs = repoConf;
      networking.hostName = "mksft-desktop";
    }

    inputs.home.nixosModules.home-manager
    #inputs.flatpaks.nixosModules.declarative-flatpak
    #inputs.nixos-cosmic.nixosModules.default

    inputs.nixHW.nixosModules.common-cpu-amd
    inputs.nixHW.nixosModules.common-cpu-amd-pstate
    inputs.nixHW.nixosModules.common-cpu-amd-zenpower
    inputs.nixHW.nixosModules.common-gpu-amd
    inputs.nixHW.nixosModules.common-pc
    inputs.nixHW.nixosModules.common-pc-ssd

    ../shared/configuration.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ] ++
  (lib.mapModulesRec' ../../modules import);

  specialArgs = { inherit inputs system; };
}
