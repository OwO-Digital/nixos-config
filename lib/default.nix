{ lib, inputs, repoConf ,... }:

let
	inherit (lib) makeExtensible;
	extLib = makeExtensible (self:
	let
		callLibs = file: import file { inherit lib inputs repoConf; };
	in {

		import  = callLibs ./import.nix;
		options = callLibs ./options.nix;

		inherit (self.import)  filterFolder importNixFiles mapHosts;
		inherit (self.options) ;

	});
in extLib
