{ inputs, lib, repoConf, ... }:

lib.nixosSystem {
	system = "x86_64-linux";

	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}

		inputs.home.nixosModules.home-manager

		../../modules/users.nix
		../../modules/desktop/awesome.nix

		../shared/configuration.nix
		./hardware-configuration.nix
		./configuration.nix
	];
}
