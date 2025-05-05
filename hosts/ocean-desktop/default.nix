{ inputs, lib, repoConf, ... }:

let system = "x86_64-linux"; in
lib.nixosSystem {
  inherit system;

  modules = [
    {
      nixpkgs = repoConf;
      networking.hostName = "ocean-desktop";
    }

    inputs.home.nixosModules.home-manager
    inputs.flatpaks.nixosModules.declarative-flatpak
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    #inputs.nixos-cosmic.nixosModules.default

    # hardware modules
    inputs.nixHW.nixosModules.common-cpu-amd
    inputs.nixHW.nixosModules.common-cpu-amd-pstate # power efficiency
    inputs.nixHW.nixosModules.common-cpu-amd-zenpower # CPU monitoring
    inputs.nixHW.nixosModules.common-gpu-amd
    inputs.nixHW.nixosModules.common-pc
    inputs.nixHW.nixosModules.common-pc-ssd # trim unused blocks for faster IO

    ../shared/configuration.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ] ++
  (lib.mapModulesRec' ../../modules import);

  specialArgs = { inherit inputs system; };
}
