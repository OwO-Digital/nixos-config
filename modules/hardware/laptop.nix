{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.laptop;
in {
	options.modules.hardware.laptop = {
		enable = mkEnableOption "laptop";
	};

	config = mkIf cfg.enable {
		modules.hardware.acpi.enable       = true;
		modules.hardware.bluetooth.enable  = true;
		modules.hardware.brightness.enable = true;
		environment.systemPackages = with pkgs; mkIf config.services.xserver.enable [ networkmanagerapplet ];
	};
}
