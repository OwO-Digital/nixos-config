{ pkgs, config, lib, ... }:
let
  darkMode = true;

  wallpapers = {
    interval = 5 * 60;
    path = "${pkgs.octelly-wallpapers}";
  };
in
{
  home.packages = with pkgs.kdePackages; [
    akonadi # storage
    akonadiconsole # manager (meant for debugging, only way of logging in without full PIM apps)
    kdepim-addons # integration with Digital Clock calendar widget
    kdepim-runtime # runtime
  ];

  programs.plasma = {
    enable = true;

    fonts = rec {
      general = {
        family = "Noto Sans";
        pointSize = 10;
      };
      menu = {
        inherit (general) family;
        pointSize = general.pointSize - 2;
      };
      small = {
        inherit (general) family;
        pointSize = general.pointSize - 2;
      };
      windowTitle = {
        inherit (general) family;
        pointSize = general.pointSize - 1;
      };
      fixedWidth = {
        family = "Maple Mono NF";
        pointSize = 12;
      };
    };

    input = {
      touchpads = [
        {
          name = "SynPS/2 Synaptics TouchPad";
          vendorId = "0002";
          productId = "0007";

          naturalScroll = true;
        }
      ];
      mice = [
        {
          name = "Logitech G502 LIGHTSPEED Wireless Gaming Mouse";
          vendorId = "4403";
          productId = "299667";

          accelerationProfile = "none";
          acceleration = -0.76;
        }
      ];
    };

    kwin = {
      titlebarButtons = {
        left = [
          "more-window-actions"
        ];
        right = [
          "minimize"
          "keep-above-windows"
          "maximize"
          "close"
        ];
      };
    };

    krunner = {
      position = "center";
      activateWhenTypingOnDesktop = false;
      shortcuts.launch = "Meta+R";
    };

    spectacle = {
      shortcuts = {
        captureActiveWindow = [
          "Ctrl+Alt+Print"
          "Ctrl+Alt+Insert"
        ];
        captureCurrentMonitor = [
          "Ctrl+Print"
          "Ctrl+Insert"
        ];
        captureRectangularRegion = [
          "Ctrl+Shift+Print"
          "Ctrl+Shift+Insert"
        ];
        launchWithoutCapturing = [
          "Meta+Print"
          "Meta+Insert"
        ];
      };
    };

    hotkeys.commands = {
      launch-terminal = {
        key = "Meta+Return";
        command = "wezterm";
      };
      launch-system-monitor = {
        key = "Ctrl+Shift+Escape";
        command = "kioclient exec ${pkgs.btop}/share/applications/btop.desktop";
      };
    };

    workspace = {
      cursor = {
        size = 32;
        theme = config.home.pointerCursor.name;
      };
      #colorScheme = if darkMode then "BreezeDark" else "BreezeLight";
      colorScheme = if darkMode then "Libadw-dark" else "Libadw-light";
      #theme = if darkMode then "breeze-dark" else "breeze-light";
      theme = "default";
      #iconTheme = if darkMode then "breeze-dark" else "breeze";
      iconTheme = if darkMode then "klassy-dark" else "klassy";

      splashScreen = {
        engine = "none";
        theme = "None";
      };

      clickItemTo = "select";

      wallpaperSlideShow = wallpapers;
    };

    kscreenlocker.appearance.wallpaperSlideShow = wallpapers;

    #shortcuts = {
    #  "services/org.kde.krunner.desktop" = {
    #    _launch = [ "Search" "Meta+R" ];
    #  };
    #  "services/org.kde.dolphin.desktop" = {
    #    _launch = [ "Meta+F" ];
    #  };
    #  "services/org.kde.spectacle.desktop" = {
    #    OpenWithoutScreenshot = [ ];
    #    ActiveWindowScreenShot = [ ];

    #    CurrentMonitorScreenShot = [
    #      "Ctrl+Print"
    #      "Ctrl+Ins"
    #      "Ctrl+Del"
    #    ];

    #    RectangularRegionScreenShot = [
    #      "Ctrl+Shift+Print"
    #      "Ctrl+Shift+Ins"
    #      "Ctrl+Shift+Del"
    #    ];
    #  };
    #};

    configFile = {
      kglobalshortcutsrc = {
        "[services][org.kde.spectacle.desktop]" = {
          OpenWithoutScreenshot = "none";
          ActiveWindowScreenShot = "none";

          CurrentMonitorScreenShot = lib.concatStringsSep "\t" [
            "Ctrl+Print"
            "Ctrl+Ins"
            "Ctrl+Del"
          ];

          RectangularRegionScreenShot = lib.concatStringsSep "\t" [
            "Ctrl+Shift+Print"
            "Ctrl+Shift+Ins"
            "Ctrl+Shift+Del"
          ];
        };
        #"[services][org.kde.krunner.desktop]" = {
        #  _launch = lib.concatStringsSep "\t" [ "Search" "Meta+R" ];
        #};
        "[services][org.kde.dolphin.desktop]" = {
          _launch = "Meta+F";
        };
      };
      kdeglobals = {
        KDE.widgetStyle = "Klassy";
      };
      kwinrc."org.kde.kdecoration2" = {
        library = "org.kde.klassy";
        theme = "Klassy";
      };
      plasma-localerc.Formats = with config.home.language; {
        LC_ALL = base;

        LC_ADDRESS = address;
        LC_COLLATE = collate;
        LC_CTYPE = ctype;
        LC_MEASUREMENT = measurement;
        LC_MESSAGES = messages;
        LC_MONETARY = monetary;
        LC_NAME = name;
        LC_NUMERIC = numeric;
        LC_PAPER = paper;
        LC_TELEPHONE = telephone;
        LC_TIME = time;
      };
      plasma-localerc.Translations.LANGUAGE =
        (builtins.elemAt
          (pkgs.lib.strings.splitString "." config.home.language.base))
          0;
    };
  };
}
