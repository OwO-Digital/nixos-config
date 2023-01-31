{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.hyprland;
in {
	options.modules.desktop.hyprland = {
		enable = mkEnableOption "hyprland";
	};

	config = mkIf cfg.enable {
		programs.hyprland.enable = true;
	};
}
