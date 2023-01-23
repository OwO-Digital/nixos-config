{ lib, mkPkgs, home, nix-hw, ... }:

let
	system = "x86_64-linux";
	nixpkgs = mkPkgs system;
in 
nixpkgs.lib.nixosSystem {
	inherit system;
	
	modules = [
		{
			inherit nixpkgs;
			networking.hostName = "testvm";
		}
		./configuration.nix
	];
	
	specialArgs = { inherit home nix-hw; };
}
