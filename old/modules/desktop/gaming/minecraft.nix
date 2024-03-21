{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.minecraft;
in {
	options.modules.desktop.gaming.minecraft = {
		enable = mkEnableOption "Minecraft";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ prismlauncher jdk8 jdk17 ];
	};
}
