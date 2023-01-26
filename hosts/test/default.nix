{ inputs, repoConf, ... }:

let
	nixpkgs = inputs.nixpkgs;
	home    = inputs.home;
	nix-hw  = inputs.nix-hw;
	lib     = nixpkgs.lib;
in

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}

		# home.nixosModules.home-manager
		# lib.mapModulesRec' ../../modules import

		# ../shared/configuration.nix
		# ./hardware-configuration.nix
		# ./configuration.nix
	];
}