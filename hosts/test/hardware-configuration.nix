{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ (modulesPath + "/installer/scan/not-detected.nix" ) ];

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/nix";
			fsType = "ext4";
		};

		"/boot/efi" = {
			device = "/dev/disk/by-label/EFI";
			fsType = "vfat";
		};
	};

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}