{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.olympus;
in {
	options.modules.desktop.gaming.olympus = {
		enable = mkEnableOption "olympus";
	};

	config = mkIf cfg.enable {
		services.flatpak = {
			enable = true;
			packages = [ "flathub:app/io.github.everestapi.Olympus//stable" ];
			remotes = {
				"flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
			};
		};
	};
}
