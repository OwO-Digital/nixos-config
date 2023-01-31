{ config, pkgs, ... }: {

	modules = {
		desktop.awesome = {
			enable = true;
			package = pkgs.awesome-git;
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
