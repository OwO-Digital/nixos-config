{ pkgs, ... }: {
  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        itch.enable = true;
        olympus.enable = true;
        minecraft.enable = true;
        sunshine.enable = true;
        utils.overlays.vkbasalt = true;
        emulation = {
          enable = true;
          nintendo = {
            switch = true;
            wii = true;
          };
        };
      };
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
      hyprland = {
	  	enable = true;
		debug = false;
	  };
    };
    system = {
      sound.enable = true;
      xorg = {
        enable = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # p sure this was here only for Davinki
      #rocmPackages.clr.icd
    ];
  };

  programs.corectrl.enable = true;

  virtualisation.vmware.host = {
    enable = true;
    extraConfig = ''
      # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';
  };

  services.flatpak.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  networking.firewall.allowedTCPPorts = [
    25565 # minecra
    3216 # EA App
  ];
  networking.firewall.allowedUDPPorts = [
    25565 # minecra
    3216 # EA App
  ];
}
