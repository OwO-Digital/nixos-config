{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.bluetooth;
in {
	options.modules.hardware.bluetooth = {
		enable = mkEnableOption "bluetooth";
	};

	config = mkIf cfg.enable {
		hardware = {
			bluetooth = {
				enable = true;
				package = pkgs.bluez;
			};
			enableRedistributableFirmware = true;
		};
		environment.systemPackages = with pkgs; mkIf config.services.xserver.enable [ blueberry ];
	};
}