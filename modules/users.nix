{ config, options, lib, pkgs, home-manager, ... }:

with builtins;
with lib;
with lib.ext;
let cfg = config.modules.users;
in {
	options.modules.users = mkOpt types.attrs {
		apro = { desc = "Emily Aproxia"; };
		octelly = { desc = "Eli Štefků"; };
	};

	nixosCfg = mapAttrs cfg (n: v: {
		description = v.desc;
		isNormalUser = true;
		extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ];
		homeMode = "755";
		initialPassword = "gay";
	});
	
	homeCfg = mapAttrs cfg (n: v:
		let dir = "../users/${n}"; in {
		home = {
			username = n;
			homeDirectory = "/home/${n}";
			stateVersion = "22.11";
			file.".face".source = "${dir}/avatar.png";
		};
		imports = [
			"${dir}"
		];
	});

	config.home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users = homeCfg;
	};

	config.users = {
		users = nixosCfg;
		mutableUsers = true;
		defaultUserShell = pkgs.zsh;
	};
}