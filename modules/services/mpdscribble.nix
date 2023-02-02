{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.services.mpdscribble;
in {
	options.modules.services.mpdscribble = {
		enable = mkEnableOption "mpdscribble";
	};

	config = mkIf cfg.enable {
		systemd.user.services = {
 	       mpdscribble.wantedBy = ["default.target"];
 	   };

		services.mpdscribble.enable = true;
	};
}
