{ config, pkgs, ... }:

# Niri notes
# FIXME: apps refuse to use Kwallet even after
#        setting up the portal and disabling Gnome Keyring
# FIXME: loading the niri-flake NixOS module breaks building
#        with complaints about options being declared twice

{
  imports = [
    # Inherit home-manager settings, where possible
    ./defaults_from_hm.nix

    # KDE Wallet
    ./keyring.nix

    # notification center
    ./swaync.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  programs.niri.settings.input = {
    mouse = {
      accel-profile = "flat";
      accel-speed = -0.76;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    config.niri = {
      "org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];

      default = [ "gtk" ];
    };
  };

  home.sessionVariables = {
    # Electron
    NIXOS_OZONE_WL = 1;
    # some Java apps
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  programs.niri.settings.spawn-at-startup = [
    # XWayland support
    {
      command = [ "${pkgs.xwayland-satellite}" ];
    }
  ];


  programs.niri.settings.binds = with config.lib.niri.actions; {
    # NOTE:
    # `Mod` is a special modifier that is equal to `Super` when running niri on a TTY,
    # and to `Alt` when running niri as a nested winit window
    "Mod+Return".action = spawn "wezterm";
    "Mod+WheelScrollDown".action = focus-workspace-down;
    "Mod+WheelScrollUp".action = focus-workspace-up;

    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+WheelScrollRight".action = focus-column-right;
  };

  programs.niri.settings.outputs = {
    "PNP(BNQ) BenQ RL2455 84E04417SL0" = {
      position = { x = -1080; y = 0; };
      transform.rotation = 270;
    };
    "PNP(AOC) 24G2W1G3- 1J4PBHA005536" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 165.003;
      };
      variable-refresh-rate = true;
    };
  };
}
