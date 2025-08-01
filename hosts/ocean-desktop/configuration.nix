{ config, pkgs, lib, ... }: {

  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        olympus.enable = false;
        minecraft.enable = true;
        sunshine.enable = true;
        emulation = {
          enable = true;
          nce.pc_engine = true;
          nintendo = {
            ds = true;
            gamecube = true;
            gb = true;
            gba = true;
            nes = true;
            snes = true;
            switch = true;
            wii = true;
          };
          sony = {
            ps3 = true;
            ps2 = true;
            psp = true;
          };
        };
        #ports = {
        #  enable = true;
        #  zelda.majora = true;
        #  zelda.ocarina = true;
        #};
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

  nix.settings = {
    system-features = [
      "gccarch-znver3"
    ];
  };

  hardware.graphics = {
    enable = true;
    #extraPackages = with pkgs; [
    #  # p sure this was here only for Davinki
    #  #rocmPackages.clr.icd
    #];
  };

  programs.corectrl.enable = true;

  virtualisation.waydroid.enable = true;

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
    wayvr-dashboard
    wlx-overlay-s

    # VRChat creation
    #unityhub # broken 6.7.2025
    alcom
    vrc-get

    ydotool

    looking-glass-client # good VM video
    #scream # good VM audio
  ];

  boot.kernelPackages = lib.mkForce pkgs.unstable-znver3.linuxPackages_zen;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    apfs
  ];

  boot.kernelModules = [
    "kvm-amd"
    "vfio"
    "vfio-pci"
    "vfio_iommu_type1"
  ];
  boot.kernelParams = [
    "iommu=pt"

    # WARN:
    # https://www.reddit.com/r/VFIO/comments/63hr88/why_is_pcie_acs_overridedownstreammultifunction/dfv4n4u/
    "pcie_acs_override=downstream,multifunction"

    #"vfio-pci.ids=1002:67ef,1002:aae0"
    "pci=noats" # AMD-Vi times out without this
  ];

  # this prevents the amdgpu module from loading during boot
  # (and thus prevent amdgpu from snatching out VM guest GPU)
  # the module still loads later and binds to the host GPU
  boot.blacklistedKernelModules = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "vfio_pci" ];
  boot.initrd.availableKernelModules = [ ];

  # seems to be pulling in amdgpu way too early
  boot.initrd.includeDefaultModules = false;

  boot.initrd.preDeviceCommands = ''
    modprobe -i vfio-pci
    echo "vfio-pci" > /sys/bus/pci/devices/0000:07:00.0/driver_override
    echo "vfio-pci" > /sys/bus/pci/devices/0000:07:00.1/driver_override
    echo 0000:07:00.0 > /sys/bus/pci/drivers_probe
    echo 0000:07:00.1 > /sys/bus/pci/drivers_probe
  '';

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 octelly qemu-libvirtd -"
    "f /dev/shm/scream 0660 octelly qemu-libvirtd -"
  ];
  #systemd.user.services.scream-ivshmem = {
  #  enable = true;
  #  description = "Scream IVSHMEM";
  #  serviceConfig = {
  #    ExecStart = "${pkgs.scream}/bin/scream -m /dev/shm/scream -o pulse -v";
  #    Restart = "always";
  #  };
  #  wantedBy = [ "multi-user.target" ];
  #  requires = [ "pulseaudio.service" ];
  #};

  #boot.extraModprobeConfig = ''
  #  softdep drm pre: vfio-pci
  #  options vfio-pci ids=1002:67ef,1002:aae0
  #'';

  #boot.initrd.availableKernelModules = [ "amdgpu" "vfio-pci" ];

  #services.desktopManager.cosmic = {
  #  enable = true;
  #  xwayland.enable = true;
  #};



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

  networking.firewall.enable = false;

  networking.firewall.allowedTCPPorts = [
    25565 # minecra
    3216 # EA App
  ];
  networking.firewall.allowedUDPPorts = [
    25565 # minecra
    3216 # EA App
  ];
  networking.firewall.allowedTCPPortRanges = [
    # FTP active mode (KIO + 3DS ftpd)
    # ``cat /proc/sys/net/ipv4/ip_local_port_range``
    { from = 32768; to = 60999; }
  ];

  # WARN: experimental gaming settings
  #       https://github.com/ryuheechul/dotfiles/blob/b31301b146b8efd33170ffede8861379cb87c62f/nix/nixos/recipes/perf-tweaks.nix#L45

  #boot.kernel.sysctl."vm.swappiness" = 1;
  # let system reclaim some RAM in the background
  # (we have 32GB, no neeed to be so aggressive)
  boot.kernel.sysctl."vm.swappiness" = 20;
  boot.kernel.sysctl."vm.compaction_proactiveness" = 0;
  boot.kernel.sysctl."vm.page_lock_unfairness" = 1;
  systemd.tmpfiles.settings."10-gaming-hugepages.conf" = {
    "/sys/kernel/mm/transparent_hugepage/enabled".w = {
      #argument = "always";
      # huge advantage for gaming,
      # but no need to force it on everything
      argument = "madvise";
    };
    "/sys/kernel/mm/transparent_hugepage/khugepaged/defrag".w = {
      argument = "0";
    };
    "/sys/kernel/mm/transparent_hugepage/shmem_enabled".w = {
      argument = "advise";
    };
  };
}
