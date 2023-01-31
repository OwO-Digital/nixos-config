{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.brightness;
in {
	options.modules.hardware.brightness = {
		enable = mkEnableOption "brightness";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ brightnessctl ];
	};
}
