{ config, inputs, lib, pkgs, system, ... }:

{
  home = {
    packages = with pkgs; [
      pavucontrol
      pulsemixer
      maple-mono-NF
      ranger
      cinnamon.nemo-with-extensions
      firefox
      vivaldi
      vivaldi-ffmpeg-codecs
      armcord
      prismlauncher
      openjdk17-bootstrap

      rnix-lsp
      nixpkgs-fmt

      networkmanagerapplet
      networkmanager-l2tp

      libgnome-keyring
      picom
      pantheon.pantheon-agent-polkit
      numlockx
      udiskie
      xfce.xfce4-power-manager
      remmina
    ];
    keyboard = {
      layout = "us,cz(qwerty)";
      options = "grp:win_space_toggle";
    };
  };

  fonts.fontconfig.enable = true;

  programs.chromium = {
    enable = true;
    package = (pkgs.chromium.override {
      ungoogled = true;
      channel = "ungoogled-chromium";
    });
    commandLineArgs = [
      "--force-dark-mode"
      "--enable-features=WebUIDarkMode"
      "--disable-features=ClearDataOnExit"
      "--ozone-platform-hint=auto" # automatic wayland
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
    enableSyntaxHighlighting = true;
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
      "awesome".source = ./awesome;
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
}

