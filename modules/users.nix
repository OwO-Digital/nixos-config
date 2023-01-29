{ config, pkgs, lib, ... }:

with builtins;
with lib;
let
	cfg = config.modules.users;

	nixosCfg = mapAttrs 
		(n: v: {
			description = v.desc;
			isNormalUser = true;
			extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ];
			homeMode = "755";
			initialPassword = "gay";
		}) cfg;
	
	homeCfg = mapAttrs
		(n: v:
			let dir = (toString ../users/${n}); in {
			home = {
				username = n;
				homeDirectory = "/home/${n}";
				stateVersion = "22.11";
				file.".face".source = "${dir}/avatar.png";
			};
			imports = [
				# "${dir}"
			];
		}
	) cfg;
in {
	options.modules.users = mkOption {
		type = types.attrs;
		default = {
			apro = { desc = "Emily Aproxia"; };
			octelly = { desc = "Eli Štefků"; };
		};
	};

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
