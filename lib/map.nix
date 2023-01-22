{self, lib, inputs, config, ...}:
let
	inherit (builtins) baseNameOf readDir;
	inherit (lib)      filterAttrs forEach hasSuffix mapAttrs mkOption nixosSystem;
in
rec {
	importNixFiles = dir:
		forEach
			mapAttrsToList (name: _: dir + ("/" + name))
				filterAttrs
					(k: v: v == "regular" && hasSuffix ".nix" k)
					readDir dir
	import;

	mapHosts = dir:
		forEach
			mapAttrs (name: _: dir + ("/" + name))
				filterAttrs
					(k: v: v == "directory")
					readDir dir
		(hostDir:
			host = baseNameOf hostDir;
			host = import hostDir
			{inherit nixpkgs home nix-hw;};
		)
}
