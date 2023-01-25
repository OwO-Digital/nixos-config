{
	description = "the gayest flake that you have ever seen";

	inputs = {
		home.url   = "github:nix-community/home-manager";
		nix-hw.url = "github:nixos/nixos-hardware/master";
		f2k.url    = "github:fortuneteller2k/nixpkgs-f2k";
		nur.url    = "github:nix-community/NUR";

		unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		stable.url   = "github:nixos/nixpkgs/nixos-22.11";
		master.url   = "github:nixos/nixpkgs/master";

		nixpkgs.follows             = "unstable";
		home.inputs.nixpkgs.follows = "nixpkgs";
		f2k.inputs.nixpkgs.follows  = "nixpkgs";
	};

	outputs = {
		self,
		nixpkgs,
		nix-hw,
		home,
		nur,
		f2k,
		...
	} @ inputs:
	let
		inherit (lib.ext) importNixFiles mapModules mapHosts;
		
		repoConf = {
			config = {
				allowUnfree = true;
				allowBroken = true;
			};
			
			overlays = importNixFiles ./overlays ++
				[
					nur.overlay
					f2k.overlays.default	
				];
		};

		lib = nixpkgs.lib.extend (final: prev: {
			ext = import ./lib
			{ inherit inputs repoConf; lib = final; };
		});

	in {
		lib = lib.ext;

		nixosModules = mapModules ./modules;
		nixosConfigurations = mapHosts ./hosts;
	};
}
