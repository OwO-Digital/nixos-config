{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.prismlauncher;
in {
	options.modules.desktop.gaming.prismlauncher = {
		enable = mkEnableOption "Prism Launcher";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ prismlauncher jdk8 jdk17 ];
	};
}
