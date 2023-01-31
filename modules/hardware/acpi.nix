{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.acpi;
in {
	options.modules.hardware.acpi = {
		enable = mkEnableOption "acpi";
	};

	config = mkIf cfg.enable {
		services = {
			acpid.enable = true;
			upower.enable = true;
		};
	};
}
