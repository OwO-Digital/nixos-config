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
in
{
  home = {
    packages = with pkgs; [
      pavucontrol
      pulsemixer
      maple-mono-NF
      ranger

      (discord.override {
        # remove any overrides that you don't want
        withOpenASAR = true;
        withVencord = true;
      })

      #cinnamon.nemo-with-extensions

      libsForQt5.dolphin
      libsForQt5.dolphin-plugins
      libsForQt5.kio
      libsForQt5.kio-admin
      libsForQt5.kio-extras
      libsForQt5.kimageformats
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
      parsec-bin

      luakit

      nextcloud-client
      qownnotes

      rnix-lsp
      nixpkgs-fmt

      # sway
      swaysome
      swww
      sov
      clipman
      wl-clipboard
      playerctl
      brightnessctl
      pamixer
      waybar
      swaynotificationcenter

      onagre
      wofi

      #nvtop

      (xfce.thunar.override {
        thunarPlugins = with pkgs.xfce; [
          thunar-volman
          thunar-archive-plugin
        ];
      })


      networkmanagerapplet
      networkmanager-l2tp

      libgnome-keyring
      picom
      pantheon.pantheon-agent-polkit
      numlockx

      #udiskie
      #xfce.xfce4-power-manager
      #remmina

      osu-lazer-bin
      srb2kart

      # flameshot and dependencies
      flameshot
      grim

      mate.engrampa

      newsflash

      wezterm
    ];
    pointerCursor = {
      package = posysCursors;
      name = "Posy_Cursor_Black";
    };
    keyboard = {
      layout = "us,cz(qwerty)";
      options = "grp:win_space_toggle";
    };
    file.".dmrc".text = ''
      [Desktop]
      Session=sway
    '';
  };

  #fonts.fontconfig.enable = true;

  programs.firefox = {
    enable = true;
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          # essentials
          bitwarden
          ublock-origin
          darkreader
          sponsorblock
          stylus

          # Steam
          steam-database

          # YouTube
          youtube-shorts-block
          return-youtube-dislikes

          # RSS
          boring-rss

          # Minecraft
          modrinthify

          # GitHub
          notifier-for-github

          # Reddit
          old-reddit-redirect
          reddit-enhancement-suite

          # LG TV agenda
          pronoundb
        ];
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

  #programs.thunar = {
  #  enable = true;
  #  plugins = with pkgs.xfce; [
  #    thunar-volman
  #    thunar-archive-plugin
  #  ];
  #};

  #services.gvfs.enable = true;
  #services.tumbler.enable = true;

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
      ms-vscode.makefile-tools
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
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      # theming
      "workbench.colorTheme" = "Sonokai Shusia";
      "workbench.iconTheme" = "material-icon-theme";
      "material-icon-theme.folder.color" = "#e5c463";

      "window.menuBarVisibility" = "toggle";

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
    enableAutosuggestions = true;
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

  home.sessionVariables = {
    EDITOR = "nvim";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "video" = [ "mpv.desktop" ];
        "audio" = [ "mpv.desktop" ];
        "text" = [ "neovim.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi.desktop " ];
        "x-scheme-handler/https" = [ "vivaldi.desktop " ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = null;
      publicShare = null;
      templates = null;

      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };

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
    };
  };

  gtk.enable = true;
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = darkMode;
  };
  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = darkMode;
  };

  gtk.iconTheme.name = if darkMode then "Colloid-pink-default-dark" else "Colloid-pink-default-light";
  gtk.iconTheme.package =
    (pkgs.colloid-icon-theme.override {
      schemeVariants = [ "default" ];
      colorVariants = [ "pink" ];
    });

  gtk.cursorTheme.name = "Posy_Cursor_Black";
  gtk.cursorTheme.package = posysCursors;

  #qt.enable = true;
  ##qt.platformTheme = "gnome";
  #qt.platformTheme = "qtct";
  #qt.style.name = "kvantum";
  ##qt.style.package = pkgs.adwaita-qt;
  ##qt.style.name = if darkMode then "adwaita-dark" else "adwaita";

  imports = [
    ./desktop_environments/sway
  ];
}

