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
	hardware.bluetooth.enable = true;
    system = {
      sound.enable = true;
      xorg = {
        enable = true;
      };
    };
  };

  boot.loader.grub.extraEntries = ''
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os {
    insmod part_gpt
    insmod ext2
	search --no-floppy --fs-uuid --set=root 3063-D8B4
    linux /vmlinuz-linux-zen root=PARTUUID=d3fe8664-76c7-4bae-8503-846206587e17 rw
    initrd /initramfs-linux-zen.img
}
  '';

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
  services.tailscale.enable = true;

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
