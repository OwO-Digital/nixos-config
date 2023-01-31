{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.awesome;
in {
	options.modules.desktop.awesome = {
		enable = mkEnableOption "awesome";
		package = mkPackageOption pkgs "awesome" { default = [ "awesome-git" ]; };
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ luajit ];

		services.xserver.windowManager.awesome = {
			enable = true;
			package = cfg.package;
		};
	};
}
