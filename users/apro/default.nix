{ config, inputs, lib, pkgs, system, ... }:

# note: Unused let in expression
#			 - Octelly
#let # run = import ../../misc/bin/run.nix { inherit pkgs; };
#in
{
	home = {
		packages = (with pkgs; [
			(pcmanfm.override { withGtk3 = true; })
			tor-browser-bundle-bin
			wlr-randr
			rofi-wayland
			scrot
			#picom-dccsillag
			ranger
			obsidian
			zed-editor
			nicotine-plus # yarr harr
			obs-studio
			blockbench-electron
			#jrnl
			feh
			ncdu
			duf
			playerctl
			pamixer
			pulsemixer
			dconf
			btop
			htop
			libinput-gestures
			mpv
			telegram-desktop
			st-emi
			stable.deluge
			inputs.zen-browser.packages.${system}.default
			vesktop
			nheko
			go-hass-agent

			(giph.override { ffmpeg = (ffmpeg_6.override { ffmpegVariant = "full"; }); })
			# etterna
			comma
		]);

		pointerCursor = {
			x11.enable = true;
			gtk.enable = true;
			name = "phinger-cursors-light";
			package = pkgs.phinger-cursors;
			size = 16;
		};

		sessionVariables = {
			"TERMINAL" = "ghostty";
			"EDITOR" = "nvim";
			"BROWSER" = "zen-beta";
		};

		file.".dmrc".text = ''
[Desktop]
Session=awesome
					'';
	};

	gtk = {
		enable = true;


		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};

		font = {
			name = "Atkinson Hyperlegible Next";
			size = 12;
		};

		gtk3 = {
			theme = {
				name = "phocus";
				package = pkgs.everblush.phocus;
			};
			extraConfig = {
				gtk-xft-antialias = 1;
				gtk-xft-hinting = 1;
				gtk-xft-hintstyle = "hintslight";
				gtk-xft-rgba = "rgb";
				gtk-decoration-layout = "menu:";
			};
		};

		gtk4.extraCss = let
			theme = import ../../misc/themes/everblush/cols.nix;
		in with theme; ''
@define-color surface-strongest #${dbg};
@define-color surface-strong #${bg};
@define-color surface-moderate #${abg};
@define-color surface-weak #${lbg};
@define-color surface-weakest #${mg};

@define-color white-strongest rgb(255, 255, 255);
@define-color white-strong rgba(255, 255, 255, 0.87);
@define-color white-moderate rgba(255, 255, 255, 0.34);
@define-color white-weak rgba(255, 255, 255, 0.14);
@define-color white-weakest rgba(255, 255, 255, 0.06);

@define-color black-strongest rgb(0, 0, 0);
@define-color black-strong rgba(0, 0, 0, 0.87);
@define-color black-moderate rgba(0, 0, 0, 0.42);
@define-color black-weak rgba(0, 0, 0, 0.15);
@define-color black-weakest rgba(0, 0, 0, 0.06);

@define-color red-tint #${c1}99;
@define-color red-normal #${c1};
@define-color red-light #${c1};
@define-color orange-tint #fab38799;
@define-color orange-normal #fab387;
@define-color orange-light #fab387;
@define-color yellow-normal #${c3};
@define-color yellow-light #${c3};
@define-color green-tint #${c2}99;
@define-color green-normal #${c2};
@define-color green-light #${c2};
@define-color cyan-normal #${c6};
@define-color cyan-light #${c6};
@define-color blue-normal #${c4};
@define-color blue-light #${c4};
@define-color purple-normal #${c5};
@define-color purple-light #${c5};
@define-color pink-normal #f5c2e7;
@define-color pink-light #f5c2e7;

@define-color accent_color @blue-light;
@define-color accent_bg_color @blue-normal;
@define-color accent_fg_color @white-strong;

@define-color destructive_color @red-light;
@define-color destructive_bg_color @red-tint;
@define-color destructive_fg_color @white-strong;

@define-color success_color @green-light;
@define-color success_bg_color @green-tint;
@define-color success_fg_color @white-strong;

@define-color warning_color @orange-light;
@define-color warning_bg_color @orange-tint;
@define-color warning_fg_color @white-strong;

@define-color error_color @red-light;
@define-color error_bg_color @red-tint;
@define-color error_fg_color @white-strong;

@define-color window_bg_color @surface-strong;
@define-color window_fg_color @white-strong;

@define-color view_bg_color @surface-strong;
@define-color view_fg_color @white-strong;

@define-color headerbar_bg_color @surface-strongest;
@define-color headerbar_fg_color @white-strong;
@define-color headerbar_border_color @surface-moderate;
@define-color headerbar_backdrop_color @surface-strongest;
@define-color headerbar_shade_color transparent;

@define-color card_bg_color @white-weakest;
@define-color card_fg_color @white-strong;
@define-color card_shade_color @white-weak;

@define-color dialog_bg_color @surface-weak;
@define-color dialog_fg_color @white-strong;

@define-color popover_bg_color @surface-weakest;
@define-color popover_fg_color @white-strong;

@define-color shade_color @black-strongest;
@define-color scrollbar_outline_color @white-weakest;

@define-color borders transparent;

@define-color sidebar_bg_color @surface-strongest;
@define-color sidebar_fg_color @white-strong;
@define-color sidebar_backdrop_color @surface-strongest;
@define-color sidebar_shade_color @surface-strongest;


/*
window contents {
    background: @surface-strongest;
    box-shadow: none;
}
*/

popover contents, popover arrow {
	background: @surface-weakest;
}

.solid-csd {
	padding: 0;
}

headerbar {
    padding: 0.3em;
    padding-top: calc(0.3em + 3px);
}
		'';
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
				"default-web-browser" = [ "zen-beta.desktop" ];
				"text/html" = [ "zen-beta.desktop" ];
				"x-scheme-handler/http" = [ "zen-beta.desktop" ];
				"x-scheme-handler/https" = [ "zen-beta.desktop" ];
				"x-scheme-handler/about" = [ "zen-beta.desktop" ];
				"x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
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
			# awesome.source = ./dots/awesome;
			picom.source = ./dots/picom;
			rofi.source = ./dots/rofi;
			"libinput-gestures.conf".source = ./dots/libinput-gestures.conf;

			"mimeapps.list".force = true;
		};
	};

	services = {
		gnome-keyring.enable = true;
	};

	imports = [
		./modules/shell/fish.nix
		# ./modules/shell/zsh.nix
		./modules/shell/starship.nix
		./modules/shell/utils.nix
		./modules/shell/fetch.nix

		# ./modules/apps/discocss.nix
		./modules/apps/firefox.nix
		./modules/apps/foot.nix
		./modules/apps/ghostty.nix
		./modules/apps/mpd.nix
		./modules/apps/vscodium.nix
		./modules/apps/wezterm.nix

		./modules/wms/hyprland
	];
}
