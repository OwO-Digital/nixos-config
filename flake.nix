{
	description = "the gayest flake that you have ever seen";

	inputs = {
		home.url   = "github:nix-community/home-manager";
		nixHW.url = "github:nixos/nixos-hardware/master";
		f2k.url    = "github:fortuneteller2k/nixpkgs-f2k";
		nur.url    = "github:nix-community/NUR";

		unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		stable.url   = "github:nixos/nixpkgs/nixos-22.11";
		master.url   = "github:nixos/nixpkgs/master";

		nixpkgs.follows             = "unstable";
		home.inputs.nixpkgs.follows = "nixpkgs";
		f2k.inputs.nixpkgs.follows  = "nixpkgs";

		### newm is currently unmaintained...
		# newm = {
		# 	url = "github:jbuchermn/newm";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = {
		self,
		nixpkgs,
		nur,
		f2k,
		...
	} @ inputs:
	let
		inherit (lib.ext) importNixFiles mapHosts;
		
		repoConf = {
			config = {
				allowUnfree = true;
				allowBroken = true;
				permittedInsecurePackages = [
					"electron-11.5.0"
				];
			};
			
			overlays = importNixFiles ./overlays ++
				[
					nur.overlay
					f2k.overlays.default	
				];
		};

		lib = nixpkgs.lib.extend (final: prev: {
			ext = import ./lib
			{ inherit inputs repoConf; lib = prev; };
		});

	in {
		# nixosModules = mapModulesRec ./modules;
		nixosConfigurations = mapHosts ./hosts;
	};
}
