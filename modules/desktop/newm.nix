{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.newm;
in {
	options.modules.desktop.newm = {
		enable = mkEnableOption "newm";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ newm ];
		services.xserver.displayManager.sessionPackages = with pkgs; [ newm ];
	};
}
