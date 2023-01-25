{ inputs, repoConf, ... }:

let
	nixpkgs =  inputs.nixpkgs;
	home    =  inputs.home;
	nix-hw  =  inputs.nix-hw;
in

nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	
	modules = [
		{
			nixpkgs = repoConf;
			networking.hostName = "testvm";
		}
		../shared/configuration.nix
		./hardware-configuration.nix
		# ./configuration.nix
	];
	
	specialArgs = { inherit home; };
}
