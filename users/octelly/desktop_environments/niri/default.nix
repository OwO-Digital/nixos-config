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

    #./screenshots.nix
    ./osd.nix
    ./wallpaper.nix
    ./window_rules.nix
    ./xwayland.nix

    # KDE integration
    ./kde_integration.nix

    # notification center
    ./swaync.nix

    # App launcher / search
    #./gauntlet.nix # FIXME: https://github.com/project-gauntlet/gauntlet/issues/73

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
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];

      default = [ "kwallet" "gtk" "kde" ];
    };
  };

  home.sessionVariables = {
    # Electron
    NIXOS_OZONE_WL = 1;
    # some Java apps
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };


  programs.niri.settings.binds = with config.lib.niri.actions; let
    sh = spawn "sh" "-c";
  in
  {
    # NOTE:
    # `Mod` is a special modifier that is equal to `Super` when running niri on a TTY,
    # and to `Alt` when running niri as a nested winit window
    "Mod+Return" = {
      action = spawn "wezterm";
      hotkey-overlay.title = "Open Terminal";
    };
    "Mod+Shift+q" = {
      action = quit;
      hotkey-overlay.title = "Logout";
    };

    "Mod+q".action = close-window;
    "Mod+d".action = fullscreen-window;
    "Control+Mod+Space".action = toggle-window-floating;

    "Mod+WheelScrollDown".action = focus-workspace-down;
    "Mod+WheelScrollUp".action = focus-workspace-up;

    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+WheelScrollRight".action = focus-column-right;

    "Mod+Tab".action = toggle-overview;

    "Mod+w" = {
      action = spawn
        (builtins.toString (pkgs.writeScript "maximize" ''
          niri msg action expand-column-to-available-width;
          niri msg action reset-window-height;
        ''));
      hotkey-overlay.title = "Maximize Window";
    };
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

  # FIXME: disabled entirely until I can blacklist my Dualsense specifically
  programs.niri.settings.input.touchpad.enable = false;

  programs.niri.settings.window-rules = [
    {
      border.enable = false;
      clip-to-geometry = true;
      draw-border-with-background = false;
      focus-ring.enable = true;
      geometry-corner-radius =
        let
          r = 12.0;
        in
        {
          top-left = r;
          top-right = r;
          bottom-left = r;
          bottom-right = r;
        };
    }
  ];
}
