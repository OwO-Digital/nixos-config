{ lib, nixpkgs, pkgsConf, home, nix-hw, ... }:

nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	
	modules = [
		{
			nixpkgs = pkgsConf;
			networking.hostName = "testvm";
		}
		./configuration.nix
	];
	
	specialArgs = { inherit home; };
}
