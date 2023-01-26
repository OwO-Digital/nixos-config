{ inputs, lib, repoConf, ... } @ args:

let
	inherit (lib) makeExtensible;
	extLib = makeExtensible (self:
	let
		callLibs = file: import file args;
	in {

		import  = callLibs ./import.nix;
		options = callLibs ./options.nix;

		inherit (self.import)  filterFolder importNixFiles mapHosts mapModules mapModulesRec mapModulesRec';
		inherit (self.options) mkOpt mkBoolOpt mkStringOpt mkStrListOpt;

	});
in extLib
