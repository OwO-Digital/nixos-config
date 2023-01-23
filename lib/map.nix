{ self, lib, nixpkgs, home, nix-hw, ... }:
let
	inherit (builtins) import readDir;
	inherit (lib) filterAttrs forEach hasSuffix mapAttrs mapAttrsToList;
in
rec {
	filterFolder = f: dir:
		mapAttrs (n: _: (dir + "/" + n))
			filterAttrs
			(f)
			(readDir dir);

	importNixFiles = dir:
		forEach
			mapAttrsToList
				(_: v: v)
				filterFolder
					(n: v: v == regular && hasSuffix ".nix" n)
					dir
			(file: import file);

	mapHosts = dir:
		mapAttrs
			filterFolder
				(n: v: v == directory && n != "shared")
				dir
			(n: p:
				import p
					{ inherit nixpkgs home nix-hw; }
			);
}
