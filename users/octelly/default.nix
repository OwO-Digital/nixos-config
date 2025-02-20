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
  posysCursors = pkgs.stdenv.mkDerivation rec {
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
  };
  klassy = pkgs.nur.repos.shadowrz.klassy-qt6;
  #klassy = with pkgs; (stdenv.mkDerivation rec {
  #  pname = "klassy";
  #  #version = "6.2.breeze6.2.1";

  #  #src = fetchFromGitHub {
  #  #  owner = "paulmcauley";
  #  #  repo = "klassy";
  #  #  rev = version;
  #  #  hash = "sha256-tFqze3xN1XECY74Gj0nScis7DVNOZO4wcfeA7mNZT5M=";
  #  #};
  #  version = "6.3";

  #  src = fetchFromGitHub {
  #    owner = "ivan-cukic";
  #    repo = "wip-klassy";
  #    rev = "01b8a6c29008e1667d0d02a0d3069f70009a9185";
  #    hash = "sha256-9IZhO8a8URTYPv6/bf7r3incfN1o2jBd2+mLVptNRYo=";
  #  };

  #  nativeBuildInputs = with kdePackages; [
  #    cmake
  #    extra-cmake-modules
  #    wrapQtAppsHook
  #  ];

  #  buildInputs = with kdePackages; [
  #    qtbase
  #    qtdeclarative
  #    qttools

  #    frameworkintegration
  #    kcmutils
  #    kdecoration
  #    kiconthemes
  #    kwindowsystem

  #    qtsvg
  #    kcolorscheme
  #    kconfig
  #    kcoreaddons
  #    kdecoration
  #    kguiaddons
  #    ki18n
  #    kirigami
  #    kwidgetsaddons
  #  ];

  #  cmakeFlags = [
  #    "-DCMAKE_INSTALL_PREFIX=$out"
  #    "-DBUILD_TESTING=OFF"
  #    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  #    "-DBUILD_QT5=OFF"
  #    "-DBUILD_QT6=ON"
  #  ];

  #  meta = {
  #    description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop";
  #    homepage = "https://github.com/paulmcauley/klassy";
  #    platforms = lib.platforms.linux;
  #    license = with lib.licenses; [
  #      bsd3
  #      cc0
  #      gpl2Only
  #      gpl2Plus
  #      gpl3Only
  #      gpl3Plus # KDE-Accepted-GPL
  #      mit
  #    ];
  #    maintainers = with lib.maintainers; [ pluiedev ];
  #    mainProgram = "klassy-settings";
  #  };
  #});
  schildichat-desktop-appimage = with pkgs;
    let
      pname = "schildichat-desktop";
      version = "1.11.86-sc.0.test.0";
      src = fetchurl {
        url = "https://github.com/SchildiChat/schildichat-desktop/releases/download/v${version}/SchildiChatAlpha-${version}.AppImage";
        hash = "sha256-tRPRvMZ1sP2t1KiHVdNwGxfTr4JVC3fSmaHfkM9gKWg=";
      };

      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    appimageTools.wrapType2 rec {
      inherit pname version src;
      nativeBuildInputs = [ makeWrapper ];

      #FIXME: still uses xwayland for some reason
      extraInstallCommands = ''
        wrapProgram $out/bin/${pname} \
          --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

        install -Dm444 ${appimageContents}/*.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/*.desktop \
          --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'

        cp -r ${appimageContents}/usr/share/icons $out/share
      '';
    };
  videomass = with pkgs.python3Packages; buildPythonPackage rec {
    pname = "videomass";
    version = "5.0.21";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-+l086zSsqO5AtEsLLp6CFOF4iAuor/xAFty0gCwniKg=";
    };

    build-system = [
      babel
      hatchling
      setuptools # distutils
    ];

    dependencies = [
      pkgs.ffmpeg-full
      pypubsub
      wxpython
      yt-dlp
    ];
  };
in
{
  home = {
    packages = with pkgs;
      [
        #warble

        #pavucontrol
        pulsemixer
        maple-mono-NF
        #ranger

        ffmpeg-full
        #videomass

        qalculate-qt

        #(discord.override {
        #  withOpenASAR = true;
        #  withVencord = true;
        #})
        vesktop
        telegram-desktop

        # Matrix clients
        #beeper
        # - doesn't count
        # -- desktop version heavier than any other non-game SW I can think of

        # "SchildiChat stable"
        # + based on Element and supports most features
        # - PWA or Electron
        # - doesn't do authenticated media

        #fluffychat
        # + relatively lightweight (Flutter)
        # - doesn't distinguish sub-spaces well
        # - Flutter CSD bug
        # - weirdly picky with some media (e.g. doesn't load Discord bridge media)

        #schildichat-desktop-appimage
        # + based on current Element and works
        # - forces XWayland (never seen Electron do this)
        # -- shares some poor UI/UX with Element for now (vanilla Element bad)

        #cinny-desktop
        # + relatively lightweight (Tauri)
        # + good defaults
        # -- doesn't do sub-spaces at all

        #neochat
        # + native QT
        # + uses Plasma's UnifiedPush (notifications without background process)
        # -- extremely poor E2EE (I don't think I've seen a single encrypted message load)
        # -- doesn't do sub-spaces (seems to at least be aware of them?)

        # conclusion: I hate Matrix clients

        nur.repos.deeunderscore.nheko-unstable
        #nur.repos.deeunderscore.nheko-krunner

        localsend

        appimage-run

        heroic
        r2modman

        #cinnamon.nemo-with-extensions

        #libsForQt5.dolphin
        #libsForQt5.dolphin-plugins
        #libsForQt5.kio
        #libsForQt5.kio-admin
        #libsForQt5.kio-extras
        #libsForQt5.kimageformats
        #libsForQt5.qtstyleplugins
        #qgnomeplatform
        #qgnomeplatform-qt6

        #bitwarden
        #(vivaldi.override {
        #  proprietaryCodecs = true;
        #  vivaldi-ffmpeg-codecs = vivaldi-ffmpeg-codecs;
        #  enableWidevine = true;
        #  widevine-cdm = widevine-cdm;
        #  commandLineArgs = chromiumFlags;
        #})
        #parsec-bin

        #luakit

        #qownnotes

        #rnix-lsp
        #nixpkgs-fmt
        #manix

        #vmware-workstation
        bottles

        #gpt4all

        gittyup
        jetbrains.idea-community


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

        jamesdsp

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

        #httpdirfs
        #fooyin

        #udiskie
        #xfce.xfce4-power-manager
        #remmina

        #osu-lazer-bin
        #srb2kart
        #gamescope
        #mangohud
        #tmuf
        tetrio-desktop
        xonotic-glx
        #emulationstation-de
        inputs.aagl.packages.${pkgs.system}.sleepy-launcher

        # plasma theme thing
        klassy
        kde-rounded-corners
        inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        inputs.darkly.packages."${system}".darkly-qt6
        breeze-icons-chameleon

        # GTK theme
        adw-gtk3

        kdePackages.kclock
        kdePackages.ktorrent
        kdePackages.partitionmanager

        # spelling stuff
        # is also used by Plasma
        aspell
        aspellDicts.cs
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science

        #krdc

        inputs.zen-browser.packages."${system}".default

        # flameshot and dependencies
        #flameshot
        #grim

        # archive manager
        #mate.engrampa

        gimp-with-plugins
        inkscape-with-extensions
        #aseprite

        planify
        newsflash
        eyedropper
        junction

        wezterm
        waypipe # Xorg SSH forwarding but for Wayland
        waycheck
      ];
    pointerCursor = {
      package = posysCursors;
      name = "Posy_Cursor_Black";
    };
    keyboard = {
      layout = "us,cz(qwerty)";
      options = "grp:win_space_toggle";
    };

    language =
      let
        C = "C";
        austrian_english = "en_AT.UTF-8";
        british_english = "en_GB.UTF-8";
        czech = "cs_CZ.UTF-8";
      in
      rec {
        base = british_english;

        address = czech;
        measurement = czech;
        monetary = czech;
        name = czech;
        numeric = C;
        paper = czech;
        telephone = czech;
        time = austrian_english;

        # sorting
        collate = C;
        # byte sequence interpreting
        ctype = C;
        # displayed language
        messages = base;

      };

    # was here for intellij and could probably be done better with a fhs env dev shell
    #file.".sdks/jdk17-openjfx".source = (pkgs.jdk17.override { enableJavaFX = true; });
  };

  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-pipewire-audio-capture
    ];
  };

  programs.mpv = {
    enable = true;
    config = {

      # replaced by uosc
      osd-bar = false;
      border = false;

    };

    scripts = with pkgs.mpvScripts; [
      uosc # better OSD
      thumbfast # thumbnails for hover
      mpris # media controls integration
      reload # automatic reload for stuck online videos
      sponsorblock
    ];

    scriptOpts.thumbfast = {
      network = true;
    };
  };

  programs.floorp = {
    enable = true;

    nativeMessagingHosts = lib.optional config.programs.plasma.enable pkgs.kdePackages.plasma-browser-integration;

    policies = {
      "3rdparty" = {
        Extensions = {
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            environment.base = "https://vw.owo.digital/";
          };
        };
      };

      DefaultDownloadDirectory = config.xdg.userDirs.download;
      DontCheckDefaultBrowser = true;

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = true;

        SkipOnboarding = true;
        Locked = true;
      };
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      PasswordManagerEnabled = false;

      Preferences =
        let
          locked = x: {
            Status = "locked";
            Value = x;
          };
        in
        {
          "widget.use-xdg-desktop-portal.file-picker" = locked 1;
          "widget.use-xdg-desktop-portal.location" = locked 1;
          "widget.use-xdg-desktop-portal.mime-handler" = locked 1;
          "widget.use-xdg-desktop-portal.open-uri" = locked 1;
          "widget.use-xdg-desktop-portal.settings" = locked 1;
        };
    };

    profiles = {
      old-default = {
        id = 1;
        name = "Old default";
        path = "old-default";
      };
      main = {
        id = 0;
        isDefault = true;

        extensions = (with pkgs.nur.repos.rycee.firefox-addons; [
          # essentials
          scroll_anywhere
          bitwarden
          kagi-search
          ublock-origin

          # misc
          clearurls

          # useful from time to time
          tab-session-manager
          tab-reloader

          # customisation
          stylus
          violentmonkey

          # Steam
          steam-database

          # YouTube
          sponsorblock
          youtube-shorts-block
          return-youtube-dislikes

          # Reddit
          old-reddit-redirect
          reddit-enhancement-suite
        ]) ++ lib.optional config.programs.plasma.enable pkgs.nur.repos.rycee.firefox-addons.plasma-integration;

        settings = {
          # Disable autofill & passwords
          "browser.formfill.enable" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;

          # Sync settings
          "services.sync.engine.prefs" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.addons" = false;
          #"identity.fxaccounts.account.device.name" 

          # Look and feel
          "font.default.x-western" = "sans-serif";

          "floorp.tabbar.style" = 2;
          "floorp.browser.tabbar.settings" = 2;
          "floorp.browser.tabs.verticaltab" = true;
          "floorp.verticaltab.hover.enabled" = true;

          "floorp.browser.sidebar.enable" = false;
          "floorp.browser.ssb.toolbars.disabled" = true;

          "floorp.lepton.interface" = 3;
          "floorp.disable.fullscreen.notification" = true;

          "floorp.browser.workspaces.enabled" = false;

          "devtools.toolbox.host" = "window";

          "browser.urlbar.suggest.trending" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;

          "browser.toolbars.bookmarks.visibility" = "never";

          "browser.tabs.warnOnClose" = false;

          "browser.startup.homepage" = "https://home.owo.digital/";

          # automatically enable HM extensions
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
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


  services.kdeconnect = {
    inherit (config.programs.plasma) enable;
    indicator = true;

    package = pkgs.kdePackages.kdeconnect-kde;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "zedokai"
    ];

    userSettings = {
      # meta
      #telemetry.metrics = false;
      auto_update = false; # wouldn't work anyway

      # controls
      vim_mode = true;
      base_keymap = "VSCode";

      # editor font
      buffer_font_family = "Maple Mono NF";
      buffer_font_size = 14;

      # UI font
      ui_font_family = "Noto Sans";
      ui_font_size = 14;

      # theming
      theme = "Zedokai Darker";

      languages.Nix.language_servers = [ "${pkgs.nil}/bin/nil" "!nixd" ];
      lsp.nil.formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
    };
  };

  programs.vscode = {
    enable = true;
    extensions = (with pkgs.open-vsx; [
      # make thing usable
      vscodevim.vim

      # theming
      sainnhe.sonokai
      pkief.material-icon-theme

      # language support
      #bungcip.better-toml
      tamasfe.even-better-toml
      ms-pyright.pyright
      ms-python.python
      ms-python.isort
      jnoortheen.nix-ide
      #ms-vscode.makefile-tools
      wayou.vscode-todo-highlight
      spgoding.datapack-language-server
    ]) ++ (with pkgs.vscode-marketplace; [
      # language support
      sumneko.lua
      vgalaktionov.moonscript
      lijin.yuescript
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

      "nix.enableLanguageServer" = true;
      "nix.serverSettings".nil.formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      "nix.serverPath" = "${pkgs.nil}/bin/nil";

      # theming
      "workbench.preferredDarkColorTheme" = "Sonokai Shusia";
      "workbench.colorTheme" = "Sonokai Shusia";
      "workbench.iconTheme" = "material-icon-theme";
      "material-icon-theme.folder.color" = "#e5c463";

      "window.menuBarVisibility" = "classic";
      "window.autoDetectColorScheme" = true;
      "window.titleBarStyle" = "custom";
      "window.customTitleBarVisibility" = "auto";

      "editor.fontFamily" = "'Maple Mono NF', 'Cartograph CF', 'FiraCode Nerd Font Mono', 'monospace', monospace";
      "debug.console.fontFamily" = "'Maple Mono NF', 'Cartograph CF', 'FiraCode Nerd Font Mono', 'monospace', monospace";
      "editor.fontLigatures" = "'cv02', 'cv03', 'cv04'";
      "editor.fontVariations" = true;
      "editor.fontSize" = 15;
      "debug.console.fontSize" = 15;

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

      "editor.minimap.enabled" = false;
      "workbench.startupEditor" = "none";

      # terminal
      "terminal.external.linuxExec" = "${pkgs.wezterm}/bin/wezterm";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.cursorStyle" = "line";
      #"terminal.integrated.defaultProfile.linux" = "zsh";
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

      # Vim
      "vim.useSystemClipboard" = true;
      "vim.enableNeovim" = true;
      "vim.neovimPath" = "${pkgs.neovim}/bin/nvim";
      "vim.hlsearch" = true;
    };
  };

  programs.kitty = {
    enable = false;
    font = {
      name = "Maple Mono NF";
      size = 14;
    };
    extraConfig = ''
      			include ./themes/sonokai-shusia.conf
      			background_opacity 0.9
      		'';
  };

  #programs.zsh = {
  #  enable = true;
  #  autosuggestion.enable = true;
  #  syntaxHighlighting.enable = true;
  #  enableVteIntegration = true;
  #  autocd = true;
  #  historySubstringSearch.enable = true;
  #};

  #programs.fzf = {
  #  enable = true;
  #  enableZshIntegration = true;
  #};

  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = true;
    };
  };

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

  #programs.anyrun = {
  #  enable = false;
  #  config =
  #    let
  #      fraction = x: { fraction = x; };
  #    in
  #    {
  #      x = fraction 0.5;
  #      y = fraction 0.4;
  #      width = fraction 0.35;
  #      ignoreExclusiveZones = true;
  #      plugins = with inputs.anyrun.packages.${system}; [
  #        # desktop entries
  #        applications
  #        # unicode symbols
  #        symbols
  #        # shell commands
  #        shell
  #        # calculator
  #        rink
  #      ];
  #    };
  #};

  home.sessionVariables = {
    EDITOR = "nvim";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    NIXOS_OZONE_WL = 1;

    LANGUAGE = config.home.language.base;
    LANG = config.home.language.base;
    LC_ALL = config.home.language.base;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = rec {
      enable = true;
      defaultApplications = {
        "video" = [ "mpv.desktop" ];
        "audio" = [ "mpv.desktop" ];
        "text" = [ "nvim.desktop" ];

        "default-web-browser" = [ "re.sonny.Junction.desktop" ];
        "text/html" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/http" = [ "re.sonny.Junction.desktop " ];
        "x-scheme-handler/https" = [ "re.sonny.Junction.desktop " ];
        "x-scheme-handler/unknown" = [ "re.sonny.Junction.desktop " ];
      };
      associations.added = defaultApplications;
    };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config.plasma.default = [ "kde" "*" ];

      # NOTE: "extra" is misleading here
      # you need to set this if you set xdg.portal.enable to true
      extraPortals = lib.optional config.programs.plasma.enable pkgs.xdg-desktop-portal-kde;
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
        "HomepageIsNewTabPage" = true;
        "ShowHomeButton" = false;
      };
      "kitty/themes/sonokai-shusia.conf".source = ./sonokai-shusia.conf;
      "wezterm".source = pkgs.stdenv.mkDerivation {
        name = "octelly-wezterm-config";
        src = ./wezterm-src;

        nativeBuildInputs = with pkgs; [
          luajitPackages.moonscript
        ];

        buildPhase = ''
          mkdir -p $out

          moonc -t $out .
        '';
      };
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

  imports = [
    #./desktop_environments/sway
    ./git.nix
    ./desktop_environments/plasma
    ./shell
  ];
}
