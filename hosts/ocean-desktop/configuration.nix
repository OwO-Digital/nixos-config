{ pkgs, ... }: {

  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        olympus.enable = false;
        minecraft.enable = true;
        sunshine.enable = true;
        emulation = {
          enable = true;
          switch.ryujinx = true;
          wii = true;
        };
        ports = {
          enable = true;
          zelda.majora = true;
          zelda.ocarina = true;
        };
        utils.overlays.vkbasalt = true;
      };
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
    };
    system = {
      sound.enable = true;
      xorg = {
        enable = true;
      };
    };
    hardware.bluetooth.enable = true;
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

  # for dev stuff
  virtualisation.docker.enable = true;

  # VR
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
  programs.adb.enable = true; # wired ALVR
  environment.systemPackages = with pkgs; [
    wlx-overlay-s

    # VRChat creation
    unityhub
    alcom
    vrc-get
  ];

  # required for NixOS SteamVR to work
  # https://wiki.nixos.org/wiki/VR/en#SteamVR
  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];

  services.flatpak.enable = true;

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=150%"
    ];
  };

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
