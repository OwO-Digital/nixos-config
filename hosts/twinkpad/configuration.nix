{ config, pkgs, ... }: {

	modules = {
		desktop = {
			gaming = {
				steam.enable 		= true;
				itch.enable 		= true;
				olympus.enable 		= true;
				minecraft.enable 	= true;
			};
			awesome = {
				enable = true;
				package = pkgs.awesome-git;
			};
			sway.enable = true;
		};
		hardware.laptop.enable = true;
		system = {
			sound.enable = true;
			xorg = {
				enable = true;
				layout = "fck";
			};
		};
	};
}
