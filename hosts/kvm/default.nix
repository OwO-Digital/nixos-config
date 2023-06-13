{ inputs, lib, repoConf, ... }:

let system = "x86_64-linux"; in
lib.nixosSystem {
	inherit system;

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "nix-kvm";
		}

		inputs.home.nixosModules.home-manager

		../shared/configuration.nix
		./configuration.nix
		./hardware-configuration.nix
	] ++
	(lib.mapModulesRec' ../../modules import);

	specialArgs = { inherit inputs system; };
}
