{ config, inputs, lib, pkgs, system, ... }:

let
  chromiumFlags = [
    #"--force-dark-mode"

    "--ignore-gpu-blocklist"
    "--enable-reader-mode"
    "--smooth-scrolling"
    "--enable-quic"

    "--download-bubble"
    "--enable-system-notifications"

    "--enable-gpu-rasterization"
    "--enable-zero-copy"
    #"--disable-gpu-driver-bug-workarounds"
    "--enable-native-gpu-memory-buffers"

    "--enable-features=VaapiVideoDecoder"
    "--use-gl=egl"

    "--ozone-platform-hint=auto" # automatic wayland
  ];
  darkMode = true;
  posysCursors = (pkgs.stdenv.mkDerivation rec {
    pname = "posy-improved-cursor-linux";
    version = "1.6";
    src = pkgs.fetchFromGitHub {
      owner = "simtrami";
      repo = pname;
      rev = version;
      hash = "sha256-i0N/QB5uzqHapMCDl6h6PWPJ4GOAyB1ds9qlqmZacLY=";
    };
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r Posy* $out/share/icons/
    '';
  });
  klassy = with pkgs; (stdenv.mkDerivation rec {
    pname = "klassy";
    version = "6.1.breeze6.0.3";

    src = fetchFromGitHub {
      owner = "paulmcauley";
      repo = "klassy";
      rev = version;
      hash = "sha256-D8vjc8LT+pn6Qzn9cSRL/TihrLZN4Y+M3YiNLPrrREc=";
    };

    nativeBuildInputs = with kdePackages; [
      cmake
      extra-cmake-modules
      wrapQtAppsHook
    ];

    buildInputs = with kdePackages; [
      qtbase
      qtdeclarative
      qttools

      frameworkintegration
      kcmutils
      kdecoration
      kiconthemes
      kwindowsystem

      qtsvg
      kcolorscheme
      kconfig
      kcoreaddons
      kdecoration
      kguiaddons
      ki18n
      kirigami
      kwidgetsaddons
    ];

    cmakeFlags = [
      "-DCMAKE_INSTALL_PREFIX=$out"
      "-DBUILD_TESTING=OFF"
      "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
      "-DBUILD_QT5=OFF"
      "-DBUILD_QT6=ON"
    ];

    meta = {
      description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop";
      homepage = "https://github.com/paulmcauley/klassy";
      platforms = lib.platforms.linux;
      license = with lib.licenses; [
        bsd3
        cc0
        gpl2Only
        gpl2Plus
        gpl3Only
        gpl3Plus # KDE-Accepted-GPL
        mit
      ];
      maintainers = with lib.maintainers; [ pluiedev ];
      mainProgram = "klassy-settings";
    };

  });
  #warble = (pkgs.stdenv.mkDerivation rec {
  #  pname = "warble";
  #  version = "2.0.1";
  #  src = pkgs.fetchFromGitHub {
  #    owner = "avojak";
  #    repo = pname;
  #    rev = version;
  #    hash = "sha256-kRFwcH/rPUw8GwMDwNvtuqPyZ4+GgPeoBcxUhO9PrMs=";
  #  };
  #  buildInputs = with pkgs; [
  #    flatpak
  #    flatpak-builder
  #    which
  #  ];
  #  preBuild = ''
  #    make flatpak-init
  #  '';
  #});
  firefoxMainProfileName = "main";
in
rec {
  home = {
    packages = with pkgs; [
      #warble

      pavucontrol
      pulsemixer
      maple-mono-NF
      ranger

      qalculate-qt

      #(discord.override {
      #  withOpenASAR = true;
      #  withVencord = true;
      #})
      vesktop
      telegram-desktop
      beeper

      appimage-run

      #cinnamon.nemo-with-extensions

      tetrio-desktop

      #libsForQt5.dolphin
      #libsForQt5.dolphin-plugins
      #libsForQt5.kio
      #libsForQt5.kio-admin
      #libsForQt5.kio-extras
      #libsForQt5.kimageformats
      #libsForQt5.qtstyleplugins
      #qgnomeplatform
      #qgnomeplatform-qt6

      bitwarden
      #(vivaldi.override {
      #  proprietaryCodecs = true;
      #  vivaldi-ffmpeg-codecs = vivaldi-ffmpeg-codecs;
      #  enableWidevine = true;
      #  widevine-cdm = widevine-cdm;
      #  commandLineArgs = chromiumFlags;
      #})
      #parsec-bin

      #luakit

      #nextcloud-client
      #qownnotes

      #rnix-lsp
      nixpkgs-fmt
      manix

      ## sway
      #swaysome
      #swww
      #sov
      #clipman
      #wl-clipboard
      #playerctl
      #brightnessctl
      #pamixer
      #waybar
      #swaynotificationcenter

      #onagre
      #wofi

      mpv

      #gtklock
      #gtklock-userinfo-module

      #nvtopPackages.intel

      #(xfce.thunar.override {
      #  thunarPlugins = with pkgs.xfce; [
      #    thunar-volman
      #    thunar-archive-plugin
      #  ];
      #})

      jellyfin-media-player
      moonlight-qt


      #networkmanagerapplet
      #networkmanager-l2tp

      #libgnome-keyring
      #picom
      #pantheon.pantheon-agent-polkit
      #numlockx

      #udiskie
      #xfce.xfce4-power-manager
      #remmina

      #osu-lazer-bin
      #srb2kart
      #gamescope
      #mangohud
      #tmuf

      # plasma theme thing
      klassy

      #krdc

      # flameshot and dependencies
      #flameshot
      #grim

      # archive manager
      #mate.engrampa

      planify
      newsflash

      wezterm
    ];
    pointerCursor = {
      package = posysCursors;
      name = "Posy_Cursor_Black_125_175";
    };
    keyboard = {
      layout = "us,cz(qwerty)";
      options = "grp:win_space_toggle";
    };

    #file.".dmrc".text = ''
    #  [Desktop]
    #  Session=sway
    #'';

    #file."lepton" = {
    #  target = ".mozilla/firefox/${firefoxMainProfileName}/chrome/lepton";
    #  source = (pkgs.fetchFromGitHub {
    #    owner = "black7375";
    #    repo = "Firefox-UI-Fix";
    #    rev = "v8.0.0";
    #    hash = "sha256-Bw5e1/ZXal4AZUn17or2hh2VLNZu7rtfRakXZtxm/pI=";
    #  });
    #};
  };

  #fonts.fontconfig.enable = true;

  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
    };
  };

  programs.firefox = {
    enable = true;

    # turns out floorp stores it's config stuff
    # somewhere else, making this module kind of useless atm
    package = pkgs.floorp;

    #policies = {
    #  ExtensionSettings = {
    #    "*" = {
    #      blocked_install_message = "Addons must be enabled/installed via Nix";
    #      installation_mode = "blocked";
    #    };
    #    # uBlock
    #    "uBlock0@raymondhill.net" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    #    };
    #    # Bitwarden
    #    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
    #    };
    #    # Tab Session Manager
    #    "Tab-Session-Manager@sienori" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
    #    };
    #    # Plasma integration
    #    "plasma-browser-integration@kde.org" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
    #    };
    #    # RES (Reddit Enhancement Suite)
    #    "jid1-xUfzOsOFlzSOXg@jetpack" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi";
    #    };
    #    # Old Reddit redirect
    #    "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi";
    #    };
    #    # Return YouTube dislikes
    #    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
    #    };
    #    # SponsorBlock
    #    "sponsorBlocker@ajay.app" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
    #    };
    #    # Scroll Anywhere (dragging with middle click)
    #    "juraj.masiar@gmail.com_ScrollAnywhere" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/scroll_anywhere/latest.xpi";
    #    };
    #    # Stylus (custom CSS)
    #    "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
    #      installation_mode = "normal_installed";
    #      install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
    #    };
    #  };
    #};

    profiles = {
      ${firefoxMainProfileName} = {
        id = 0;
        isDefault = true;
        #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #  # essentials
        #  bitwarden
        #  ublock-origin
        #  darkreader
        #  sponsorblock
        #  stylus

        #  # Steam
        #  steam-database

        #  # YouTube
        #  youtube-shorts-block
        #  return-youtube-dislikes

        #  # RSS
        #  boring-rss

        #  # Minecraft
        #  modrinthify

        #  # GitHub
        #  notifier-for-github

        #  # Reddit
        #  old-reddit-redirect
        #  reddit-enhancement-suite

        #  # LG TV agenda
        #  pronoundb
        #];

        settings = {
          # Use XDG portals
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          # Disable autofill & passwords
          "browser.formfill.enable" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
        };


        #settings = {
        #  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        #  # Lepton theme
        #  # https://github.com/black7375/Firefox-UI-Fix
        #  "browser.proton.enabled" = true;
        #  "svg.context-properties.content.enabled" = true;
        #  "layout.css.color-mix.enabled" = true;
        #  "layout.css.backdrop-filter.enabled" = true;
        #  "browser.compactmode.show" = true;
        #  "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
        #  "layout.css.has-selector.enabled" = true;

        #  "userChrome.tab.connect_to_window" = true;
        #  "userChrome.tab.color_like_toolbar" = true;

        #  "userChrome.tab.lepton_like_padding" = true;
        #  "userChrome.tab.photon_like_padding" = false;

        #  "userChrome.tab.dynamic_separator" = true;
        #  "userChrome.tab.static_separator" = false;
        #  "userChrome.tab.static_separator.selected_accent" = false;
        #  "userChrome.tab.bar_separator" = false;

        #  "userChrome.tab.newtab_button_like_tab" = true;
        #  "userChrome.tab.newtab_button_smaller" = false;
        #  "userChrome.tab.newtab_button_proton" = false;

        #  "userChrome.icon.panel_full" = true;
        #  "userChrome.icon.panel_photon" = false;

        #  "userChrome.tab.box_shadow" = true;
        #  "userChrome.tab.bottom_rounded_corner" = true;

        #  "userChrome.tab.photon_like_contextline" = false;
        #  "userChrome.rounding.square_tab" = false;

        #  "userChrome.compatibility.theme" = true;
        #  "userChrome.compatibility.os" = true;

        #  "userChrome.theme.built_in_contrast" = true;
        #  "userChrome.theme.system_default" = true;
        #  "userChrome.theme.proton_color" = true;
        #  "userChrome.theme.proton_chrome" = true;
        #  "userChrome.theme.fully_color" = true;
        #  "userChrome.theme.fully_dark" = true;

        #  "userChrome.decoration.cursor" = true;
        #  "userChrome.decoration.field_border" = true;
        #  "userChrome.decoration.download_panel" = true;
        #  "userChrome.decoration.animate" = true;

        #  "userChrome.padding.tabbar_width" = true;
        #  "userChrome.padding.tabbar_height" = true;
        #  "userChrome.padding.toolbar_button" = true;
        #  "userChrome.padding.navbar_width" = true;
        #  "userChrome.padding.urlbar" = true;
        #  "userChrome.padding.bookmarkbar" = true;
        #  "userChrome.padding.infobar" = true;
        #  "userChrome.padding.menu" = true;
        #  "userChrome.padding.bookmark_menu" = true;
        #  "userChrome.padding.global_menubar" = true;
        #  "userChrome.padding.panel" = true;
        #  "userChrome.padding.popup_panel" = true;

        #  "userChrome.tab.multi_selected" = true;
        #  "userChrome.tab.unloaded" = true;
        #  "userChrome.tab.letters_cleary" = true;
        #  "userChrome.tab.close_button_at_hover" = true;
        #  "userChrome.tab.sound_hide_label" = true;
        #  "userChrome.tab.sound_with_favicons" = true;
        #  "userChrome.tab.pip" = true;
        #  "userChrome.tab.container" = true;
        #  "userChrome.tab.crashed" = true;

        #  "userChrome.fullscreen.overlap" = true;
        #  "userChrome.fullscreen.show_bookmarkbar" = true;

        #  "userChrome.icon.library" = true;
        #  "userChrome.icon.panel" = true;
        #  "userChrome.icon.menu" = true;
        #  "userChrome.icon.context_menu" = true;
        #  "userChrome.icon.global_menu" = true;
        #  "userChrome.icon.global_menubar" = true;

        #  "userContent.player.ui" = true;
        #  "userContent.player.icon" = true;
        #  "userContent.player.noaudio" = true;
        #  "userContent.player.size" = true;
        #  "userContent.player.click_to_play" = true;
        #  "userContent.player.animate" = true;

        #  "userContent.newTab.full_icon" = true;
        #  "userContent.newTab.animate" = true;
        #  "userContent.newTab.pocket_to_last" = true;
        #  "userContent.newTab.searchbar" = true;

        #  "userContent.page.field_border" = true;
        #  "userContent.page.illustration" = true;
        #  "userContent.page.proton_color" = true;
        #  "userContent.page.dark_mode" = true;
        #  "userContent.page.proton" = true;

        #  "browser.urlbar.suggest.calculator" = true;
        #};
        #userChrome = ''
        #  // Lepton theme
        #  @import "lepton/userChrome.css";
        #'';
        #userContent = ''
        #  // Lepton theme
        #  @import "lepton/userContent.css";
        #'';
      };
    };
  };

  programs.chromium = {
    enable = true;
    package = (pkgs.chromium.override {
      ungoogled = true;
      channel = "ungoogled-chromium";
    });
    commandLineArgs = chromiumFlags ++ [
      "--disable-features=ClearDataOnExit"
      "--remove-tabsearch-button"
      "--show-avatar-button=never"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "fiabciakcmgepblmdkmemdbbkilneeeh"; } # Tab Suspender
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return YouTube Dislike
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
    ];
  };

  programs.brave = {
    enable = false;
  };

  #programs.thunar = {
  #  enable = true;
  #  plugins = with pkgs.xfce; [
  #    thunar-volman
  #    thunar-archive-plugin
  #  ];
  #};

  #services.gvfs.enable = true;
  #services.tumbler.enable = true;

  #services.swayosd = {
  #  enable = true;
  #};

  programs.plasma = {
    enable = true;

    fonts = rec {
      general = {
        family = "Noto Sans";
        pointSize = 10;
      };
      menu = {
        family = general.family;
        pointSize = general.pointSize - 2;
      };
      small = {
        family = general.family;
        pointSize = general.pointSize - 2;
      };
      windowTitle = {
        family = general.family;
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
          productId = "0007";
          vendorId = "0002";

          naturalScroll = true;
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
      launch-krunner = {
        key = "Meta+R";
        command = "krunner";
      };
      launch-terminal = {
        key = "Meta+Return";
        command = "wezterm";
      };
      launch-file-manager = {
        key = "Meta+F";
        command = "dolphin";
      };
    };

    workspace = {
      cursor = {
        size = 32;
        theme = "Posy_Cursor_Black";
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
    };

    configFile = {
      kdeglobals = {
        KDE.widgetStyle = "Klassy";
      };
      kwinrc."org.kde.kdecoration2" = {
        library = "org.kde.klassy";
        theme = "Klassy";
      };
    };
  };

  services.kdeconnect.enable = true;

  programs.vscode = {
    enable = true;
    extensions = (with pkgs.open-vsx; [
      # make thing usable
      vscodevim.vim

      # theming
      sainnhe.sonokai
      pkief.material-icon-theme

      # language support
      bungcip.better-toml
      ms-pyright.pyright
      ms-python.python
      ms-python.isort
      jnoortheen.nix-ide
      #ms-vscode.makefile-tools
      wayou.vscode-todo-highlight
    ]) ++ (with pkgs.vscode-marketplace; [
      # language support
      sumneko.lua
      vgalaktionov.moonscript
      tnze.snbt
      mrmlnc.vscode-json5
      # this one broken somehow, bruh:
      #rust-lang.rust-analyzer

      # GitHub
      github.remotehub
      github.vscode-pull-request-github

      # remote dev
      ms-vscode.remote-repositories
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
    ]);
    userSettings = {
      # Vim controls
      #"extensions.experimental.affinity" = {
      #  "asvetliakov.vscode-neovim" = 1;
      #};

      # theming
      "workbench.preferredDarkColorTheme" = "Sonokai Shusia";
      "workbench.colorTheme" = "Sonokai Shusia";
      "workbench.iconTheme" = "material-icon-theme";
      "material-icon-theme.folder.color" = "#e5c463";

      "window.menuBarVisibility" = "toggle";
      "window.autoDetectColorScheme" = true;
      "window.titleBarStyle" = "custom";
      "window.customTitleBarVisibility" = "auto";

      "editor.fontFamily" = "'Maple Mono NF', 'Cartograph CF', 'FiraCode Nerd Font Mono', 'monospace', monospace";
      "debug.console.fontFamily" = "'Maple Mono NF', 'Cartograph CF', 'FiraCode Nerd Font Mono', 'monospace', monospace";
      "editor.fontLigatures" = "'cv02', 'cv03', 'cv04'";
      "editor.fontVariations" = true;
      "editor.fontSize" = 17;
      "debug.console.fontSize" = 17;

      "todohighlight.defaultStyle" = {
        "backgroundColor" = "#0000";
        "color" = "#f85e84";
      };
      "todohighlight.keywords" = [
        {
          "text" = "FIXME:";
          "color" = "#f85e84";
          "backgroundColor" = "#0000";
        }
      ];

      # terminal
      "terminal.external.linuxExec" = "kitty";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.cursorStyle" = "line";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.drawBoldTextInBrightColors" = false;
      "terminal.integrated.gpuAcceleration" = "on";
      "terminal.integrated.minimumContrastRatio" = 1;
      "terminal.integrated.shellIntegration.decorationsEnabled" = "never";

      # Git
      "githubPullRequests.createOnPublishBranch" = "never";
      "git.confirmSync" = false;
      "git.autofetch" = true;

      # code formatting
      "editor.formatOnSave" = true;
      "python.formatting.provider" = "black";

      # brhuhe
      "workbench.startupEditor" = "none";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF";
      size = 14;
    };
    extraConfig = ''
      			include ./themes/sonokai-shusia.conf
      			background_opacity 0.9
      		'';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    autocd = true;
    historySubstringSearch.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop.enable = true;

  dconf.settings =
    let
      color-scheme = if darkMode then "prefer-dark" else "prefer-light";
    in
    {
      "org/gnome/desktop/interface" = {
        "color-scheme" = color-scheme;
      };
      "org/freedesktop/interface" = {
        "color-scheme" = color-scheme;
      };
    };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.anyrun = {
    enable = false;
    config =
      let
        fraction = x: { fraction = x; };
      in
      {
        x = fraction 0.5;
        y = fraction 0.4;
        width = fraction 0.35;
        ignoreExclusiveZones = true;
        plugins = with inputs.anyrun.packages.${system}; [
          # desktop entries
          applications
          # unicode symbols
          symbols
          # shell commands
          shell
          # calculator
          rink
        ];
      };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    NIXOS_OZONE_WL = 1;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        #"inode/directory" = [ "nemo.desktop" ];
        #"video" = [ "mpv.desktop" ];
        #"audio" = [ "mpv.desktop" ];
        #"text" = [ "neovim.desktop" ];
        #"x-scheme-handler/http" = [ "vivaldi.desktop " ];
        #"x-scheme-handler/https" = [ "vivaldi.desktop " ];
      };
    };

    userDirs =
      let
        home = config.home.homeDirectory;
      in
      {
        enable = true;
        createDirectories = true;

        desktop = null;
        publicShare = null;
        templates = null;

        download = "${home}/Downloads";
        documents = "${home}/Documents";
        music = "${home}/Music";
        pictures = "${home}/Pictures";
        videos = "${home}/Videos";
      };

    # https://store.kde.org/p/2175326
    dataFile."color-schemes/Libadw-dark.colors".source = ./Libadw-dark.colors;
    dataFile."color-schemes/Libadw-light.colors".source = ./Libadw-light.colors;

    configFile = {
      "awesome".source = ./desktop_environments/awesome/awesomecfg;
      "chromium/policies/managed/extra.json".text = builtins.toJSON {
        "OsColorMode" = "dark";
        "WebAppInstallForceList" = [
          {
            "default_launch_container" = "window";
            "url" = "https://www.youtube.com/";
          }
        ];
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "BrowserSignin" = 0;
        "BrowserGuestModeEnabled" = false;
        "ClearBrowsingDataOnExitList" = [ ];
        "ForceEphemeralProfiles" = false;

        "BookmarkBarEnabled" = false;
        "BrowserThemeColor" = "#000000";
        "NewTabPageLocation" = "https://start.johnystar.moe/";
        "HomepageIsNewTabPage" = true;
        "ShowHomeButton" = false;
      };
      "kitty/themes/sonokai-shusia.conf".source = ./sonokai-shusia.conf;
      "qtile".source = ./desktop_environments/qtile;

      "swaync/config.json".text = builtins.toJSON {
        "control-center-exclusive-zone" = true;

        "positionX" = "center";
        "positionY" = "top";
        "control-center-positionX" = "none";
        "control-center-positionY" = "none";
        "control-center-margin-top" = 8;
        "control-center-margin-bottom" = 8;
        "control-center-margin-right" = 8;
        "control-center-margin-left" = 8;
        "control-center-width" = 500;
        "control-center-height" = 600;
        "fit-to-screen" = false;

        "layer" = "overlay";
        "control-center-layer" = "overlay";
        "cssPriority" = "user";

        "keyboard-shortcuts" = false;
        "widgets" = [
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
      };
      "swaync/style.css".source = ./swaync.css;
    };
  };

  #gtk.enable = true;
  #gtk.gtk3.extraConfig = {
  #  gtk-application-prefer-dark-theme = darkMode;
  #};
  #gtk.gtk4.extraConfig = {
  #  gtk-application-prefer-dark-theme = darkMode;
  #};

  #gtk.iconTheme.name = if darkMode then "Colloid-pink-default-dark" else "Colloid-pink-default-light";
  #gtk.iconTheme.package =
  #  (pkgs.colloid-icon-theme.override {
  #    schemeVariants = [ "default" ];
  #    colorVariants = [ "pink" ];
  #  });
  #gtk.iconTheme.name = if darkMode then "kora" else "kora-light-panel";
  #gtk.iconTheme.package = pkgs.kora-icon-theme;

  #gtk.cursorTheme.name = "Posy_Cursor_Black_125_175";
  #gtk.cursorTheme.package = posysCursors;

  #qt.enable = true;
  #qt.platformTheme = "gnome";
  #qt.platformTheme.name = "qtct";
  #qt.style.name = "kvantum";
  #qt.style.package = pkgs.adwaita-qt;
  #qt.style.name = if darkMode then "adwaita-dark" else "adwaita";

  xresources.properties = {
    # 96 is 1x
    "Xft.dpi" = 96;
  };

  #wayland.windowManager.hyprland =
  #  let
  #    strlist = list: (builtins.concatStringsSep "," list);
  #    rgba = hex: "rgba(${hex})";
  #    rgb = hex: "rgb(${hex})";

  #    tools =
  #      let
  #        bin = pkg: bin: "${pkg}/bin/${bin}";
  #      in
  #      with pkgs;
  #      {
  #        swaync = {
  #          server = bin swaynotificationcenter "swaync";
  #          client = bin swaynotificationcenter "swaync-client";
  #        };
  #        wl-clip-persist = bin wl-clip-persist "wl-clip-persist";
  #        swww = bin swww "swww";
  #        waybar = bin waybar "waybar";
  #      };

  #    workspaces_per_monitor = 9;
  #  in
  #  {
  #    enable = true;
  #    plugins = [
  #      # manual tiling
  #      inputs.hypr-hy3.packages.${system}.hy3
  #      # per monitor workspaces
  #      inputs.hypr-smw.packages.${system}.split-monitor-workspaces
  #    ];
  #    settings = {

  #      # plugin and daemons setup

  #      plugin.split-monitor-workspaces.count = workspaces_per_monitor;

  #      exec-once = with tools; [
  #        # notifications
  #        swaync.server
  #        # volume, caps lock, etc. indicator
  #        "swayosd-server"
  #        # persistent clpboard
  #        (wl-clip-persist + " --clipboard both")
  #        # wallpaper
  #        (swww + " init")
  #        # bar
  #        waybar
  #      ];

  #      # monitors

  #      monitor = [
  #        "eDP-1,1920x1080@60,0x0,1"
  #      ];

  #      # input config

  #      input = {
  #        kb_layout = strlist [
  #          "us"
  #          "cz(qwerty)"
  #        ];

  #        # layout switching with super + space
  #        kb_options = "grp:win_space_toggle";

  #        numlock_by_default = true;

  #        # 0 - Cursor movement will not change focus
  #        # 1 - Cursor movement will always change focus to the window under the cursor
  #        # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
  #        # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
  #        follow_mouse = 2;

  #        accel_profile = "flat";
  #        sensitivity = -0.25;

  #        touchpad.natural_scroll = true;
  #      };

  #      #device = lib.mapAttrs
  #      #  (key: value: value // {
  #      #    name = key;
  #      #  })
  #      #  {
  #      #    "SynPS/2 Synaptics TouchPad" = {
  #      #      sensitivity = 0;
  #      #      accel_profile = null;
  #      #    };
  #      #  };

  #      ## ThinkPad
  #      #"device:SynPS/2 Synaptics TouchPad" = {
  #      #  sensitivity = 0;
  #      #  accel_profile = null;
  #      #};

  #      ## Logitech G502 mouse
  #      ## hw conf:
  #      ## - 500 hz
  #      ## - 2400 dpi
  #      #"device:logitech-gaming-mouse-g502" = {
  #      #  sensitivity = -0.834;
  #      #};

  #      ## PS5 (DualSense) controller
  #      #"device:sony-interactive-entertainment-dualsense-wireless-controller-touchpad" = {
  #      #  enabled = false;
  #      #};

  #      # look and feel

  #      general = rec {
  #        gaps_in = 5;
  #        gaps_out = gaps_in * 2;

  #        border_size = 2;

  #        "col.active_border" = rgb "f85e84";
  #        "col.inactive_border" = rgb "2d2a2e";

  #        # do not apply sensitivity to raw input
  #        # (p sure this is the default anyway)
  #        apply_sens_to_raw = false;

  #        layout = "hy3";
  #      };

  #      layerrule = [
  #        "blur, swaync-control-center"
  #        "ignorezero, swaync-control-center"
  #        "blur, swaync-notification-window"
  #        "ignorezero, swaync-notification-window"
  #        "blur, swayosd"
  #        "ignorezero, swayosd"
  #      ];

  #      windowrulev2 = [
  #        # Flameshot fixes
  #        ## functional
  #        #"nofullscreenrequest,class:flameshot"
  #        "float,class:flameshot"
  #        "monitor 0,class:flameshot"
  #        "move 0 0,class:flameshot"
  #        ## visual
  #        "noanim,class:flameshot"
  #        "noborder,class:flameshot"
  #        "rounding 0,class:flameshot"

  #        "float,class:blueberry.py"
  #        "float,class:io.gitlab.news_flash.NewsFlash"
  #      ];

  #      decoration = {
  #        rounding = 10;
  #        drop_shadow = false;

  #        blur = {
  #          size = 7;
  #          passes = 2;
  #          popups = true;
  #        };
  #      };

  #      animations = {
  #        enabled = true;
  #        animation = [
  #          #NAME,ONOFF,SPEED,CURVE,STYLE
  #          #NAME,ONOFF,SPEED,CURVE

  #          "fade,1,2,default"
  #          "windowsIn,0"
  #          "windowsOut,0"
  #          "border,1,2,default"
  #        ];
  #      };

  #      misc = {
  #        disable_hyprland_logo = true;
  #        disable_splash_rendering = true;

  #        force_default_wallpaper = 0;

  #        # renders less frames when possible
  #        vfr = true;

  #        # Variable refresh rate
  #        # (Freesync / G-sync)
  #        # 0 - off
  #        # 1 - on
  #        # 2 - fullscreen only
  #        vrr = 1;

  #        # should reduce latency on fullscreen windows
  #        # may cause glitches
  #        no_direct_scanout = false;

  #        mouse_move_focuses_monitor = true;
  #        background_color = rgb "000000";

  #        # if there is a fullscreen window,
  #        # whether a new tiled window opened
  #        # should replace the fullscreen one or stay behind
  #        # 0 - don't do anything
  #        # 1 - focus new window
  #        # 2 - unfullscreen the fullscreen window
  #        new_window_takes_over_fullscreen = 1;
  #      };

  #      # binds

  #      # mouse
  #      bindm = [
  #        "SUPER,mouse:272,movewindow"
  #        "SUPER,mouse:273,resizewindow"
  #      ];

  #      # regular
  #      bind = [
  #        "SUPER_SHIFT,Q,exit,"
  #        # windows
  #        ## basic signals
  #        "SUPER,Q,killactive,"
  #        "SUPER,D,fullscreen,"
  #        "SUPER_CONTROL,Space,togglefloating,"
  #        ## moving focus
  #        "ALT,LEFT,hy3:movefocus,left,visible"
  #        "ALT,RIGHT,hy3:movefocus,right,visible"
  #        "ALT,UP,hy3:movefocus,up,visible"
  #        "ALT,DOWN,hy3:movefocus,down,visible"
  #        ## moving windows
  #        "CTRL_ALT,LEFT,hy3:movewindow,left"
  #        "CTRL_ALT,RIGHT,hy3:movewindow,right"
  #        "CTRL_ALT,UP,hy3:movewindow,up"
  #        "CTRL_ALT,DOWN,hy3:movewindow,down"
  #        ## tabs
  #        "SUPER,TAB,hy3:changegroup,toggletab"
  #        "ALT,TAB,hy3:focustab,right,wrap"
  #        "SHIFT_ALT,TAB,hy3:focustab,left,wrap"
  #        # notifications
  #        "SUPER,A,exec,${tools.swaync.client} -t"
  #        # terminal
  #        "SUPER,return,exec,wezterm"
  #        "CTRL_SHIFT,Escape,exec,wezterm start --no-auto-connect --always-new-process --class btop -- btop -u 500"
  #        # file manager
  #        "SUPER,F,exec,nemo"
  #        # launcher / search
  #        # note: anyrun is enabled in programs.anyrun
  #        "SUPER,R,exec,anyrun"
  #        ",XF86Search,exec,anyrun"
  #        # media
  #        ",XF86AudioMute,exec,swayosd-client --output-volume mute-toggle"
  #        ",XF86AudioMicMute,exec,swayosd-client --input-volume mute-toggle"
  #        # screenshots
  #        # note: flameshot is in home.packages
  #        "CTRL_SHIFT,INSERT,execr,zsh -c \"XDG_CURRENT_DESKTOP=Sway flameshot gui -c -p '$HOME/Pictures/$(date +%s).png'\""
  #        "CTRL,INSERT,execr,zsh -c \"XDG_CURRENT_DESKTOP=Sway flameshot full -c -p '$HOME/Pictures/$(date +%s).png'\""
  #      ] ++ (builtins.concatLists

  #        # workspace switching
  #        # -------------------
  #        # we return a list in genList,
  #        # meaning we end up with a list of lists

  #        (builtins.genList
  #          # generator function
  #          (x:
  #            let
  #              workspace = toString (x + 1);
  #            in

  #            [
  #              # change workspace
  #              "SUPER,${workspace},split-workspace,${workspace}"
  #              # move windows to workspace
  #              "SUPER_SHIFT,${workspace},split-movetoworkspace,${workspace}"
  #            ])
  #          # how long the list should be
  #          workspaces_per_monitor
  #        )
  #      );

  #      # repeat on hold
  #      binde = [
  #        # media
  #        ",XF86MonBrightnessUp,exec,swayosd-client --brightness +1"
  #        ",XF86MonBrightnessDown,exec,swayosd-client --brightness -1"
  #        ",XF86AudioRaiseVolume,exec,swayosd-client --output-volume +1"
  #        ",XF86AudioLowerVolume,exec,swayosd-client --output-volume -1"
  #      ];

  #      # pass-through binds
  #      bindrlni = [
  #        ",Caps_Lock,exec,swayosd-client --caps-lock"
  #        ",Num_Lock,exec,swayosd-client --num-lock"
  #        ",Scroll_Lock,exec,swayosd-client --scroll-lock"
  #      ];
  #    };
  #  };

  #imports = [
  #  ./desktop_environments/sway
  #];
}

