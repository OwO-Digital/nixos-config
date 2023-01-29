{ inputs, lib, repoConf, ... }:

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			_module.args = { inherit lib; };
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}

		inputs.home.nixosModules.home-manager

		../shared/configuration.nix
		./hardware-configuration.nix
		./configuration.nix
	] ++ (lib.mapModulesRec' ../../modules import);
}
