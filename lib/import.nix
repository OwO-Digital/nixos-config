{ lib, inputs, repoConf, ... }:
let
	inherit (builtins) import readDir;
	inherit (lib) filterAttrs forEach hasSuffix mapAttrs mapAttrs' mapAttrsToList nameValuePair removeSuffix;
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
					{ inherit inputs repoConf; })
			(filterFolder
				(n: v: v == "directory" && n != "shared")
				dir);

	mapModules = dir:
		mapAttrs'
			(n: v:
				let path = "${toString dir}/${n}";
				in
					if v == "directory"
						then nameValuePair n (mapModules path)
					else if v == "regular" && hasSuffix ".nix" n && n != "default.nix"
						then nameValuePair (removeSuffix ".nix" n) (import path)
					else nameValuePair "" null)
			(readDir dir);
}
