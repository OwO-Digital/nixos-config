{ config, pkgs, ... }: {

  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        olympus.enable = false;
        minecraft.enable = true;
        sunshine.enable = true;
        emulation = {
          enable = true;
          switch = true;
          wii = true;
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

  virtualisation.vmware.host = {
    enable = true;
    extraConfig = ''
      # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';
  };

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

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

  #services.davfs2 = {
  #  enable = true;
  #  settings.sections = {
  #    "/home/octelly/nextcloud" = {
  #      use_locks = false;
  #      gui_optimize = true;
  #      cache_size = 1024 * 8;
  #      table_size = 32768;
  #    };
  #  };
  #};

  #fileSystems."/home/octelly/nextcloud" = {
  #  device = "https://cloud.owo.digital/remote.php/dav/files/octelly/";
  #  fsType = "davfs";
  #  options = [
  #    #"x-systemd.automount" # mount on access
  #    "noauto" # do not mount on boot
  #    "user" # let's ordinary user to unmount
  #    "uid=octelly"
  #    "rw" # read write
  #    #"async" # ??
  #  ];
  #};

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=150%"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    3216 # EA App
  ];
  networking.firewall.allowedUDPPorts = [
    3216 # EA App
  ];
}
