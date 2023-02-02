{ inputs, lib, repoConf, ... }:

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}

		inputs.home.nixosModules.home-manager

		../shared/configuration.nix
		./configuration.nix
		./hardware-configuration.nix
	] ++
	(lib.mapModulesRec' ../../modules import);
}