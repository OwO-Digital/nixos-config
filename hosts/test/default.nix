{ inputs, lib, repoConf, ... }:

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}

		inputs.home.nixosModules.home-manager
		({ pkgs, ... }: pkgs.lib.mapModulesRec' ../../modules import)

		../shared/configuration.nix
		./hardware-configuration.nix
		./configuration.nix
	];
}