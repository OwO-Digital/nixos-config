{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.olympus;
in {
	options.modules.desktop.gaming.olympus = {
		enable = mkEnableOption "olympus";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ olympus ];
	};
}
