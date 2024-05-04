{ config, pkgs, ... }: {

	virtualisation.docker.enable = true;

	modules = {
		desktop = {
			gaming = {
				steam.enable 		= true;
				#itch.enable 		= true;
				olympus.enable 		= true;
				minecraft.enable 	= true;
			};
			awesome = {
				enable = true;
				package = pkgs.awesome-git;
			};
			hyprland.enable = true;
			# sway.enable = true;
			# river.enable = true;
		};
		hardware.laptop.enable = true;
		system = {
			sound.enable = true;
			xorg = {
				enable = true;
				#layout = "fck";
			};
		};
	};
}
