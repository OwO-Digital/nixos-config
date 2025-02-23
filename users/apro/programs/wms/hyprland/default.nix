{ config, inputs, lib, pkgs, system, ... }: {

	wayland.windowManager.hyprland = {
		enable = true;
	};

	imports = [
		./settings.nix
		./binds.nix
		./anims.nix
		./plugins.nix
	];

	home.sessionVariables.NIXOS_OZONE_WL = "1";
}
