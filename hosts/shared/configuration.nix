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

        # FIXME: doesn't work
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
    # blacklisted hosts (redirect to nowhere)
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
    hardwareClockInLocalTime = true; # Windows default
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
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
    ++ lib.optional config.services.desktopManager.plasma6.enable pkgs.kdePackages.kpmcore
    ++ lib.optional config.services.desktopManager.plasma6.enable pkgs.kdePackages.plasma-welcome;

    # WARN: polkit will error out with shells not listed here
    shells = with pkgs; [ fish zsh bash nushell elvish ];
    binsh = "${pkgs.bash}/bin/bash";

    variables = {
      # we don't mind proprietary software
      NIXPKGS_ALLOW_UNFREE = "1";

      # better touchpad (and I think touchscreen too) support
      MOZ_USE_XINPUT2 = "1";
    };

    # HOME MANAGER DOCS:
    # Note, if you use the NixOS module and have useUserPackages = true,
    # make sure to add
    pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    # to your system configuration so that the portal definitions and DE
    # provided configurations get linked.

    # we do a little debloating
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
    fish.enable = true;
    zsh.enable = true;

    # Nix helper CLI
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };

  # gtklock access to password verification (PAM)
  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  security.polkit = {
    enable = true;
  };

  security.wrappers = {
    go-hass-agent = {
      source = lib.getExe pkgs.go-hass-agent;
      owner = "root";
      group = "root";
      # https://github.com/joshuar/go-hass-agent/blob/22920ac0545c9804103fc350377f359aabd1f886/assets/postinstall.sh#L9
      capabilities = "cap_sys_rawio,cap_sys_admin,cap_mknod,cap_dac_override=+ep";
    };
  };

  services = {
    dbus.enable = true;

    # firmware updates (you probably call it BIOS)
    # Required for "Firmware Security" page of KDE's Info Center
    fwupd.enable = true;

    # SSH access
    openssh.enable = true;

    # NOTE: what is this?
    xl2tpd.enable = true;

    # GNOME filesystem mounting
    # (virtual filesystems, e.g. smb, ftp, ssh, etc.)
    gvfs.enable = true;

    # D-Bus thumbnailer
    # NOTE: what is this for?
    tumbler.enable = true;

    # CUPS (Common UNIX Printing System)
    printing = {
      enable = true;
      drivers = with pkgs; [
        epson-escpr
      ];

      # whether shared printers are advertised
      browsing = true;
    };

    # scanning (Scanner Access Now Easy Daemon)
    saned = {
      enable = true;
    };

    desktopManager.plasma6.enable = true;

    # easy local network service sharing
    # printers, files, etc.
    avahi = {
      enable = true;

      # transparent .local domain resolution
      nssmdns4 = true;
      nssmdns6 = config.services.avahi.ipv6;

      openFirewall = true;

      publish = {
        enable = true;

        addresses = true;
        domain = true;
        userServices = true;
        workstation = true;
      };
    };
  };

  # Logitech mice and other configurable devices
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # NOTE: why is this enabled?
  hardware.i2c.enable = true;

  # WARN: do not change (ever!)
  system.stateVersion = "22.11";

  # default xdg portal config
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
