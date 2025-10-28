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
        fangames = {
          ringracers = true;
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

  nix.settings = {
    system-features = [
      "gccarch-znver3"
    ];
  };

  hardware.amdgpu.opencl.enable = true;

  hardware.graphics = {
    enable = true;
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

    ydotool

    looking-glass-client # good VM video
  ];

  boot.kernelPackages = lib.mkForce pkgs.unstable-znver3.linuxPackages_zen;

  # NOTE: apfs breaks very often and is often temporarily disabled
  #boot.extraModulePackages = with config.boot.kernelPackages; [
  #  apfs
  #];

  # FIXME: test what parts of this entire vfio section are necessary
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
  boot.initrd.kernelModules = [ "vfio_pci" ];
  virtualisation.libvirtd = {
    enable = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 octelly qemu-libvirtd -"
  ];
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    # make vfio-pci a pre-dependency of the usual video modules
    # forcing it to load first
    "softdep amdgpu pre: vfio-pci"
    "softdep drm pre: vfio-pci"

    # have vfio-pci grab the RX 560 on boot
    "options vfio-pci ids=1002:67ef,1002:aae0"
  ];


  # required for NixOS SteamVR to work
  # https://wiki.nixos.org/wiki/VR/en#SteamVR
  # WARN: requires compiling the kernel
  # NOTE: opportunity taken to compile with znver3 optimizations (see above)
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

  services.tailscale.enable = true;

  # useful for kernel compilation
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

  # NOTE: stale, not used in a long while, to be tested and re-enabled if needed
  #networking.firewall.enable = false;

  networking.firewall.allowedTCPPorts = [
    25565 # minecra

    # NOTE: stale, not used in a long while, to be tested and re-enabled if needed
    #3216 # EA App
  ];
  networking.firewall.allowedUDPPorts = [
    25565 # minecra

    # NOTE: stale, not used in a long while, to be tested and re-enabled if needed
    #3216 # EA App
  ];

  # NOTE: stale, not used in a long while, to be tested and re-enabled if needed
  #networking.firewall.allowedTCPPortRanges = [
  #  # FTP active mode (KIO + 3DS ftpd)
  #  # ``cat /proc/sys/net/ipv4/ip_local_port_range``
  #  { from = 32768; to = 60999; }
  #];

  # WARN: experimental gaming settings
  #       https://github.com/ryuheechul/dotfiles/blob/b31301b146b8efd33170ffede8861379cb87c62f/nix/nixos/recipes/perf-tweaks.nix#L45
  boot.kernel.sysctl = {
    #"vm.swappiness" = 1;
    # let system reclaim some RAM in the background
    # (we have 32GB, no neeed to be so aggressive)
    "vm.swappiness" = 10;
    "vm.compaction_proactiveness" = 0;
    "vm.page_lock_unfairness" = 1;
  };
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

  # more responsive IO (hopefully)
  # partially based on: https://gitlab.com/cscs/maxperfwiz/-/blob/main/maxperfwiz
  boot.kernel.sysctl = {
    #"vm.dirty_background_bytes" = "33554432"; # ~32 MiB
    #"vm.dirty_background_bytes" = "134217728"; # ~128 MiB
    "vm.dirty_background_bytes" = "268435456"; # ~256 MiB
    #"vm.dirty_bytes" = "268435456"; # ~256 MiB
    "vm.dirty_bytes" = "536870912"; # ~512 MiB
    #"vm.dirty_bytes" = "1073741824"; # ~1 GiB
    #"vm.dirty_writeback_centisecs" = "100"; # 1 s
    "vm.dirty_writeback_centisecs" = "1500"; # 15 s
    #"vm.dirty_expire_centisecs" = "100"; # 1 s
    "vm.dirty_expire_centisecs" = "3000"; # 30 s
    "vm.min_free_kbytes" = "118654"; # ~116 MiB
  };

  boot.kernel.sysctl = {
    # unnecessary on a PC
    "kernel.nmi_watchdog" = "0";
  };

  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5055", MODE="0660"
    '';
  };
}
