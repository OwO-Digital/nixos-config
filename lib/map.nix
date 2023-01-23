{ lib, inputs, nixpkgs, pkgsConf, home, nix-hw, ... }:
let
	inherit (builtins) import readDir;
	inherit (lib) filterAttrs forEach hasSuffix mapAttrs mapAttrsToList;
in
rec {
	filterFolder = f: dir:
		mapAttrs
			(n: v: dir + ("/" + n))
			(filterAttrs
				f
				(readDir dir));

	importNixFiles = dir:
		forEach
			(mapAttrsToList
				(n: v: v)
				(filterFolder
					(n: v: v == "regular" && hasSuffix ".nix" n)
					dir))
			(file: import file { inherit inputs; });

	mapHosts = dir:
		mapAttrs
			(n: v:
				import v
					{ inherit lib nixpkgs pkgsConf home nix-hw; } )
			(filterFolder
				(n: v: v == "directory" && n != "shared")
				dir);
}
