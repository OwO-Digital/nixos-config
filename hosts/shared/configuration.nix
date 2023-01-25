{ config, pkgs, lib, ... }: {

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

		shells = with pkgs; [ bash zsh ];
		binsh  = "${pkgs.bash}/bin/bash";

		sessionVariables.MOZ_USE_XINPUT2 = "1";
	};

	users = {
		mutableUsers = true;
		defaultUserShell = pkgs.zsh;
	};

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
		}
	}

	systemd.user.services = {
        pipewire.wantedBy = ["default.target"];
        pipewire-pulse.wantedBy = ["default.target"];
    };

	services = {
		pipewire = {
			enable = true;

			jack.enable = true;
			pulse.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
		};

		dbus.enable = true;
		openssh.enable = true;

		xserver = {
			libinput = {
				mouse.accelProfile = "flat";
				touchpad = {
					middleEmulation = false;
					tapping = false;
					naturalScrolling = true;
				};
			};

			extraLayouts.codemakcz = {
				description = "Czech Programmer version of Colemak DH";
				languages = [ "en" "cs" ];
				symbolsFile = ../../misc/keymaps/fck;
			};
		};
	};

	system.stateVersion = "22.11";
}
