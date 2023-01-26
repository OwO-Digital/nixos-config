{ inputs, lib, repoConf, ... } @ args:
let
	inherit (builtins) concatLists import map readDir;
	inherit (lib) attrValues filterAttrs forEach hasSuffix id mapAttrs mapAttrs' mapAttrsToList nameValuePair pathExists removeSuffix;
in
rec {
	filterFolder = f: dir:
		mapAttrs
			(n: v: dir + ("/" + n))
			(filterAttrs
				f
				(readDir dir));

	importNixFiles = dir:
		map
			(file: import file args)
			(attrValues
				(filterFolder
					(n: v: v == "regular" && hasSuffix ".nix" n)
					dir));

	mapHosts = dir:
		mapAttrs
			(n: v:
				import v args)
			(filterFolder
				(n: v: v == "directory" && n != "shared")
				dir);

	mapModules = dir: fn:
    	mapAttrs'
    	  (n: v:
    	    let path = "${toString dir}/${n}"; in
    	    	if v == "directory" && pathExists "${path}/default.nix"
    	    		then nameValuePair n (fn path)
    	    	else if (v == "regular" &&
    	    	        hasSuffix ".nix" n &&
    	    	        n != "default.nix")
    	    		then nameValuePair (removeSuffix ".nix" n) (fn path)
    	    	else nameValuePair "" null)
    	  (readDir dir);

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
				(k: _: "${dir}/${k}")
				(filterAttrs
					(n: v: v == "directory")
					(readDir dir));
			files = attrValues (mapModules dir id);
			paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
		in map fn paths;
}
