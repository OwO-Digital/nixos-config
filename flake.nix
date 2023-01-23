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
		...
	} @ inputs:
	{
		nixpkgs.config = {
			allowUnfree = true;
			allowBroken = true;
		};

		nixpkgs.overlays = with inputs; [
			(final: prev:
			let system = final.system; in

				/*   Nixpkgs branches   */

				/*  Allows for specifying which branches to take packages from.
				 *  
				 * The branches can be accessed like so:
				 * 'pkgs.master.srb2kart'
				 * 'pkgs.stable.linuxKernel.kernels.linux_6_0'
				 */ 

				{
					unstable = import unstable { inherit config system; };
					stable   = import stable   { inherit config system; };
					master   = import master   { inherit config system; };
				
					lib = prev.lib.extend (final: prev: 
						import ./lib {
							inherit prev;
							lib = final;
							isOverlayLib = true;
						}
					);
				}
			)

			nur.overlay
			f2k.overlays.default
		];

		nixosConfigurations = lib.mapHosts ./hosts;
	};

}
