{ config, pkgs, inputs, ... }: {

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	boot = {
		kernelPackages = pkgs.linuxPackages_zen;
		loader = {
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
	};

	networking.networkmanager.enable = true;

	time = {
		timeZone = "Europe/Prague";
		hardwareClockInLocalTime = true;
	};

	i18n = {
		defaultLocale = "en_US.utf8";
		supportedLocales = [ "en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8" ];
	};

	environment = {
		systemPackages = with pkgs; [
			cmake
			coreutils
			curl
			fd
			gcc
			git
			libnotify
			lm_sensors
			man-pages
			pciutils
			ripgrep
			unrar
			unzip
			wget
			xclip
			zip
		];

		shells = with pkgs; [ zsh bash ];
		binsh  = "${pkgs.bash}/bin/bash";

		variables = {
			NIXPKGS_ALLOW_UNFREE = "1";
			MOZ_USE_XINPUT2 = "1";
		};
	};                                            

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
		};
	};

	services = {
		dbus.enable = true;
		openssh.enable = true;
	};

	system.stateVersion = "22.11";
}
