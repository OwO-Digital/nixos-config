{ config, pkgs, inputs, lib, ... }: {

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
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
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    enableStrongSwan = true;
  };

  time = {
    timeZone = "Europe/Prague";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8" ];
  };

  environment = {
    systemPackages = with pkgs; [
      aha # Required for "Firmware Security" page of KDE's Info Center
      clinfo # Required for "OpenCL" page of KDE's Info Center
      cmake
      coreutils
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
      xclip
      zip
      wireguard-tools
    ];

    shells = with pkgs; [ zsh bash ];
    binsh = "${pkgs.bash}/bin/bash";

    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      MOZ_USE_XINPUT2 = "1";
    };

    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      kmenuedit
      plasma-systemmonitor
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
  };

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

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
