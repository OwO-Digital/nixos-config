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
          nce.pc_engine = true;
          nintendo = {
            ds = true;
            gamecube = true;
            gb = true;
            gba = true;
            nes = true;
            snes = true;
            switch.ryujinx = true;
            wii = true;
          };
          sony = {
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

  hardware.graphics = {
    enable = true;
    #extraPackages = with pkgs; [
    #  # p sure this was here only for Davinki
    #  #rocmPackages.clr.icd
    #];
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

    # FIXME: tried to pin the previous version, but couldn't get it to work
    # https://github.com/NixOS/nixpkgs/issues/359680#issuecomment-2679625425

    #package = pkgs.alvr.overrideAttrs (final: prev: rec {
    #  pname = "alvr";
    #  version = "20.12.0";
    #
    #  src = pkgs.fetchFromGitHub {
    #    owner = "alvr-org";
    #    repo = "ALVR";
    #    tag = "v${version}";
    #    fetchSubmodules = true;
    #    hash = "sha256-4tilgZCUY5PehR0SQDOBahLaPVH4n5cgE7Ghw+SCgQk=";
    #  };
    #
    #  cargoDeps = prev.cargoDeps.overrideAttrs (lib.const {
    #    name = "${pname}-vendor.tar.gz";
    #    inherit (final) src;
    #    outputHash = "sha256-ocwNVdozZeF0hYDhYMshSbRHKfBFawIcO7UbTwk10xc=";
    #  });
    #});
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
