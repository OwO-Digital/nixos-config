{ config, inputs, lib, pkgs, system, ... }:

let # run = import ../..  /misc/bin/run.nix { inherit pkgs; };
in {
	home = {
		packages = with pkgs; [
			(pcmanfm.override { withGtk3 = true; })
			rofi
			scrot
			picom
			ranger
			obsidian
			nicotine-plus # yarr harr
			jrnl
			feh
			ncdu
			duf
			pamixer
			apro.st
			dconf
			btop
			htop
			libinput-gestures
			# run # credit to alpha for this
		];

		pointerCursor = {
			x11.enable = true;
			gtk.enable = true;
			name = "phinger-cursors";
			package = pkgs.phinger-cursors;
			size = 16;
		};
	};

	gtk = {
		enable = true;
		theme = {
			name = "phocus";
			package = pkgs.everblush.phocus;
		};

		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};

		font = {
			name = "Roboto Condensed";
			size = 12;
		};

		gtk3.extraConfig = {
			gtk-xft-antialias = 1;
			gtk-xft-hinting = 1;
			gtk-xft-hintstyle = "hintslight";
			gtk-xft-rgba = "rgb";
			gtk-decoration-layout = "menu:";
		};
	};

	xresources.extraConfig = import ./etc/xresources.nix;

	xdg = {
		enable = true;

		mime.enable = true;
		mimeApps = {
			enable = true;
			defaultApplications = {
				"inode/directory" = [ "pcmanfm.desktop" ];
				"video" = [ "mpv.desktop" ];
				"image" = [ "sxiv.desktop" ];
			};
		};

		userDirs = {
			enable = true;
			createDirectories = true;

			desktop = null;
			documents = null;
			publicShare = null;
			templates = null;

			download = "${config.home.homeDirectory}/Downloads";
			music = "${config.home.homeDirectory}/Music";
			pictures = "${config.home.homeDirectory}/Pictures";
			videos = "${config.home.homeDirectory}/Videos";
		};

		configFile = {
			awesome.source = ./config/awesome;
			nvim.source = ./config/nvim;
			picom.source = ./config/picom;
			rofi.source = ./config/rofi;
			"libinput-gestures.conf".source = ./config/libinput-gestures.conf;
		};
	};

	imports = [
		./programs/browser
		./programs/shell


		./programs/utils/bat.nix
		./programs/utils/direnv.nix
		./programs/utils/exa.nix
		./programs/utils/git.nix

		./programs/apps/discocss.nix
		./programs/apps/mpd.nix
		./programs/apps/vscodium.nix
	];
}
