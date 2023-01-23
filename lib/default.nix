{ lib, inputs, mkPkgs, home, nix-hw, ... }:

let
	inherit (lib) makeExtensible;
	extLib = makeExtensible (self:
	let
		callLibs = file: import file { inherit lib inputs mkPkgs home nix-hw; };
	in {

		map = callLibs ./map.nix;

		inherit (self.map) filterFolder importNixFiles mapHosts;

	});
in extLib
