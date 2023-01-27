{ config, options, pkgs, ... }:

with pkgs.lib;
with pkgs.lib.ext;
let cfg = config.modules.desktop.awesome;
in {
	options.modules.desktop.awesome = {
		enable = mkBoolOpt false;
	};

	config = mkIf cfg.enable { };
}





		# environment.systemPackages = with pkgs; [ luajit ];

		# nixpkgs.overlays = [
		# 	(final: prev: {
		# 		awesome = prev.awesome.override { lua = prev.luajit; };
		# 		awesome-git = prev.awesome-git.override { lua = prev.luajit; };
		# 	})
		# ];

		# services.xserver = {
		#   enable = true;
		# 	windowManager.awesome = {
		# 		enable = true;
		# 		package = pkgs.awesome-git;
		# 	};

		# 	displayManager.lightdm.enable = true;
		# };
