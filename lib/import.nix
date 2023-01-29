{ inputs, lib, repoConf, ... } @ args:
let
	inherit (builtins) concatLists import map readDir toString;
	inherit (lib) attrValues filterAttrs forEach hasSuffix id mapAttrs mapAttrs' mapAttrsToList nameValuePair pathExists removeSuffix;

	inheritArgs = { inherit inputs repoConf; lib = lib // { inherit filterFolder importNixFiles mapHosts mapModules mapModulesRec mapModulesRec'; }; };
	filterFolder = f: dir:
		mapAttrs
			(n: v: dir + ("/" + n))
			(filterAttrs
				f
				(readDir dir));

	importNixFiles = dir:
		map
			(file: import file inheritArgs)
			(attrValues
				(filterFolder
					(n: v: v == "regular" && hasSuffix ".nix" n)
					dir));

	mapHosts = dir:
		mapAttrs
			(n: v:
				import v inheritArgs)
			(filterFolder
				(n: v: v == "directory" && n != "shared")
				dir);

	mapModules = dir: fn:
		filterAttrs
			(n: v: v != null)
    	(mapAttrs'
    	  (n: v:
    	    let path = "${toString dir}/${n}"; in
    	    	if v == "directory" && pathExists "${path}/default.nix"
    	    		then nameValuePair n (fn path)
    	    	else if (v == "regular" &&
    	    	        hasSuffix ".nix" n &&
    	    	        n != "default.nix")
    	    		then nameValuePair (removeSuffix ".nix" n) (fn path)
    	    	else nameValuePair "" null)
    	  (readDir dir));

	mapModulesRec = dir: fn:
		mapAttrs'
			(n: v:
				let path = "${toString dir}/${n}"; in
					if v == "directory"
						then nameValuePair n (mapModules path fn)
					else if (v == "regular" &&
							hasSuffix ".nix" n &&
							n != "default.nix")
						then nameValuePair (removeSuffix ".nix" n) (fn path)
					else nameValuePair "" null)
			(readDir dir);
	
	mapModulesRec' = dir: fn:
		let
			dirs = mapAttrsToList
				(_: k: k)
				(filterFolder
					(n: v: v == "directory")
					dir);
			files = attrValues (mapModules dir id);
			paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
		in map fn paths;
in
rec {
	inherit filterFolder importNixFiles mapHosts mapModules mapModulesRec mapModulesRec';
}
