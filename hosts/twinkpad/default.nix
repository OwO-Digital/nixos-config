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
		inputs.hyprland.nixosModules.default
		inputs.nixHW.nixosModules.lenovo-thinkpad-t460s

		../shared/configuration.nix
		./configuration.nix
		./hardware-configuration.nix
	] ++
	(lib.mapModulesRec' ../../modules import);

	specialArgs = { inherit inputs system; };
}
