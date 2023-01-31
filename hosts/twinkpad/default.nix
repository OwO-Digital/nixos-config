{ inputs, lib, repoConf, ... }:

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "twinkpad";
		}

		inputs.home.nixosModules.home-manager
		inputs.hyprland.nixosModules.default
		inputs.nixHW.nixosModules.lenovo-thinkpad-t460s

		../shared/configuration.nix
		./configuration.nix
		./hardware-configuration.nix
	] ++
	(lib.mapModulesRec' ../../modules import);
}
