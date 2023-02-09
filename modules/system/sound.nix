{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.system.sound;
in {
	options.modules.system.sound = {
		enable = mkEnableOption "sound";
	};

	config = mkIf cfg.enable {
		systemd.user.services = {
			pipewire.wantedBy = ["default.target"];
			pipewire-pulse.wantedBy = ["default.target"];
		};

		services.pipewire = {
			enable = true;

			jack.enable = true;
			pulse.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
		};
	};
}
