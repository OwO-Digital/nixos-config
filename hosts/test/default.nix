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
		./configuration.nix
	];
	
	specialArgs = { inherit home; };
}
