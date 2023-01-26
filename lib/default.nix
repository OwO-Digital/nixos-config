{ inputs, lib, repoConf, ... }:

let
	inherit (lib) makeExtensible;
	extLib = makeExtensible (self:
	let
		callLibs = file: import file { inherit inputs lib repoConf; };
	in {

		import  = callLibs ./import.nix;
		options = callLibs ./options.nix;

		inherit (self.import)  filterFolder importNixFiles mapHosts mapModules mapModulesRec mapModulesRec';
		inherit (self.options) mkOpt mkBoolOpt mkStringOpt mkStrListOpt;

	});
in extLib
