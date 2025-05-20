{ config, pkgs, lib, ... }: {

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://fortuneteller2k.cachix.org"
      "https://cosmic.cachix.org/" # Cosmic DE
      "https://ezkea.cachix.org" # Hoyoverse
      "https://wezterm.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
    trusted-users = [
      "nixremote"
      "@wheel"
    ];
    lazy-trees = true;
    auto-optimise-store = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;

        #theming
        splashImage = ./boot_logo.png;
        splashMode = "normal";
        backgroundColor = "#000000";

        # install to EFI only
        efiSupport = true;
        device = "nodev";

        # look
        fontSize = 20;

        # auto populate boot entries
        useOSProber = true;

        # add netboot.xyz as an entry
        extraFiles."netboot-xyz.efi" = pkgs.netbootxyz-efi;
        extraEntries = ''
          menuentry "netboot.xyz" {
            chainloader /netboot-xyz.efi
          }
        '';

        extraConfig = builtins.concatStringsSep "\n" [
          # FIXME: this doesn't work actually, lol
          ## auto boot last choice
          # save selection as default
          "GRUB_SAVEDEFAULT=true"
          # loade the previously saved selection
          "GRUB_DEFAULT=saved"
        ];
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    enableStrongSwan = true;
  };
  networking.firewall = {
    allowedTCPPorts = [
      53317 # LocalSend
    ];
    allowedUDPPorts = [
      53317 # LocalSend
    ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDEConnect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDEConnect
    ];
  };

  networking.hosts = {
    "0.0.0.0" = [
      # Genshin logging servers (do not remove!)
      # Global version
      "sg-public-data-api.hoyoverse.com"
      "log-upload-os.hoyoverse.com"

      # Some old global logging servers
      "log-upload-os.mihoyo.com"
      "overseauspider.yuanshen.com"

      # Chinese version
      "public-data-api.mihoyo.com"
      "log-upload.mihoyo.com"

      "log-upload-os.hoyoverse.com"
      "overseauspider.yuanshen.com"
      "apm-log-upload-os.hoyoverse.com"
      "zzz-log-upload-os.hoyoverse.com"
    ];
  };

  time = {
    timeZone = "Europe/Prague";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "cs_CZ.UTF-8/UTF-8"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      aha # Required for "Firmware Security" page of KDE's Info Center
      clinfo # Required for "OpenCL" page of KDE's Info Center
      cmake
      coreutils
      cpu-x # needs a system daemon to work; CPU/GPU/HW info tool (very detailed)
      curl
      fd
      gcc
      git
      glxinfo # Required for "OpenGL (GLX)" page of KDE's Info Center
      libnotify
      lm_sensors
      man-pages
      pciutils
      ripgrep
      unrar
      unzip
      virtualglLib # Required for "OpenGL (EGL)" page of KDE's Info Center
      vulkan-tools # Required for "Vulkan" page of KDE's Info Center
      wayland-utils # Required for "Wayland" page of KDE's Info Center
      wget
      wireguard-tools
      xclip
      zip
    ]
    # adds PolicyKit rules
    ++ lib.optional config.services.desktopManager.plasma6.enable pkgs.kdePackages.kpmcore;

    # WARN: polkit will error out with shells not listed here
    shells = with pkgs; [ zsh bash nushell elvish ];
    binsh = "${pkgs.bash}/bin/bash";

    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      MOZ_USE_XINPUT2 = "1";
    };

    # HOME MANAGER DOCS:
    # Note, if you use the NixOS module and have useUserPackages = true,
    # make sure to add
    pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    # to your system configuration so that the portal definitions and DE
    # provided configurations get linked.

    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      konsole
      khelpcenter
      krdp
    ];
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    zsh.enable = true;
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    # Bitwarden system integration
    ## needs to be here to set up background services and stuff
    #goldwarden.enable = true;
  };

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  security.polkit = {
    enable = true;
  };

  services = {
    dbus.enable = true;
    fwupd.enable = true; # Required for "Firmware Security" page of KDE's Info Center

    openssh.enable = true;
    xl2tpd.enable = true;
    strongswan = {
      enable = true;
      secrets = [ "ipsec.d/ipsec.nm-l2tp.secrets" ];
    };
    gvfs.enable = true;
    tumbler.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        epson-escpr
      ];

      # whether shared printers are advertised
      browsing = true;
    };

    desktopManager.plasma6.enable = true;
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  system.stateVersion = "22.11";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
