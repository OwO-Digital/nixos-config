{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib
, # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs
, # You also have access to your flake's inputs.
  inputs
, # Additional metadata is provided by Snowfall Lib.
  home
, # The home architecture for this host (eg. `x86_64-linux`).
  target
, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format
, # A normalized name for the home target (eg. `home`).
  virtual
, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host
, # The host name for this home.

  # All other arguments come from the home home.
  config
, ...
}:
with config; {
  #octelly.shell.cli = {
  #  enable = true;
  #  ranger.enable = true;
  #};

  #octelly.env = {
  #  enable = true;
  #  appearance.dark-color-scheme = false;
  #};

  targets.genericLinux.enable = true;

  themes.gtk.adw-gtk3 = {
    enable = true;
    scheme = "dark";
  };

  home.packages = with pkgs; [
    #snowfallorg.frost
    #nil
    #owo-digital.MarioVsLuigi-bin
    #eartag

    gittyup

    fcast-receiver
  ];

  programs.tauon = {
    enable = true;
  };

  programs.rbw = {
    enable = true;
    #settings = {
    #  #email
    #  #base_url

    #  lock_timeout = 60 * 10; # seconds
    #};
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

  fonts.fontconfig = {
    #enable = true;
    defaultFonts = {
      monospace = [
        "Maple Mono NF"
      ];
    };
  };

  xdg.configFile = {

    # https://wiki.archlinux.org/title/bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
    wireplumberDisableHandsfree = {
      target = ".config/wireplumber/wireplumber.conf.d/50-bluez.conf";
      text = ''
        monitor.bluez.rules = [
          {
            matches = [
              {
                ## This matches all bluetooth devices.
                device.name = "~bluez_card.*"
              }
            ]
            actions = {
              update-props = {
                bluez5.auto-connect = [ a2dp_sink ]
                bluez5.hw-volume = [ a2dp_sink ]
              }
            }
          }
        ]
              
        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink ]
          bluez5.hfphsp-backend = "none"
        }
      '';
    };
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraPlugins = with pkgs.vimPlugins; [
      sonokai
      moonscript-vim
    ];

    globals = {
      sonokai_style = "shusia";

      # substitution live preview
      inccomand = "nosplit";

      # WARNING: blah blah this is experimental
      #          if you encounter issues, disable this
      # NOTE: seems to not be working atm anyway :)
      cmdheight = 0;
    };


    colorscheme = "sonokai";

    opts = {
      number = true;
      relativenumber = true;

      breakindent = true;

      # save undo history
      undofile = true;

      # case-insensitive search unless specified
      ignorecase = true;
      smartcase = true;

      # generally enables mouse stuff
      mouse = "a";

      # use system clipboard
      clipboard = "unnamedplus";

      # decrease update time
      updatetime = 250;

      # minimum margin lines around cursor
      scrolloff = 5;

      # mode is shown in lualine
      showmode = false;

      # linebreak so that words aren't split when wrap
      linebreak = true;
    };

    extraConfigLua = ''
      --vim.g.sonokai_style = 'shusia'
      --vim.cmd([[colorscheme sonokai]])
      
      vim.o.guifont = "${builtins.elemAt fonts.fontconfig.defaultFonts.monospace 0}:h12"
      
      if vim.g.neovide then
        vim.g.neovide_hide_mouse_when_typing = true
        vim.g.neovide_remember_window_size = true
        vim.g.neovide_cursor_animate_in_insert_mode = false
        vim.g.neovide_cursor_vfx_mode = "railgun"
      end
    '';

    editorconfig.enable = true;

    keymaps =
      let
        mkRaw = x: { __raw = x; };
      in
      [
        {
          key = "<Esc><Esc>";
          action = "<C-\\><C-n>";
          mode = "t";
        }

        # smart-splits
        {
          mode = "n";
          key = "<S-Left>";
          action = mkRaw "require('smart-splits').move_cursor_left";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<S-Down>";
          action = mkRaw "require('smart-splits').move_cursor_down";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<S-Up>";
          action = mkRaw "require('smart-splits').move_cursor_up";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<S-Right>";
          action = mkRaw "require('smart-splits').move_cursor_right";
          options.silent = true;
        }

        {
          mode = "n";
          key = "<A-Left>";
          action = mkRaw "require('smart-splits').resize_left";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<A-Down>";
          action = mkRaw "require('smart-splits').resize_down";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<A-Up>";
          action = mkRaw "require('smart-splits').resize_up";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<A-Right>";
          action = mkRaw "require('smart-splits').resize_right";
          options.silent = true;
        }

      ];

    plugins = rec {

      lsp = {
        enable = true;
        servers = {
          # JSON
          jsonls.enable = true;

          # Nix
          nil_ls = {
            enable = true;
            extraOptions = {
              formatting.command = "${pkgs.nixpkgs-fmt}";
            };
          };

          # LUA
          lua_ls.enable = true;

          # Python
          pyright.enable = true;
        };
      };

      lsp-format.enable = true;

      lspkind = {
        enable = true;
        cmp.enable = cmp.enable;
      };

      #lspsaga = {
      #  enable = true;

      #  # breadcrumbs
      #  symbolInWinbar.enable = true;
      #};

      # better splits with support for wez, kitty, tmux
      smart-splits = {
        enable = true;
      };

      trouble.enable = true;

      # detect tab/spaces and width
      sleuth.enable = true;

      treesitter = {
        enable = true;

        # use tresitter as fold method
        folding = true;
      };

      treesitter-context = {
        enable = true;
        settings = rec {
          max_lines = 6;
          min_window_height = 3 * max_lines;
        };
      };

      treesitter-refactor = {
        enable = true;
        highlightDefinitions.enable = true;

        # bound to 'grr' by default
        smartRename.enable = true;
      };

      nvim-tree = {
        enable = true;
        syncRootWithCwd = true;

        # colours are enough imo
        renderer.icons.show.git = false;
      };

      # icons provider for nvim-tree, trouble and other plugins
      web-devicons.enable = true;

      # a lua powered greeter like vim-startify / dashboard-nvim
      alpha = {
        enable = true;
        layout = [
          {
            type = "text";
            val = [
              "hello gays welcome to my nixvim config"
              ""
              "⠀⠀⠀⢰⠶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠶⠲⣄⠀"
              "⠀⠀⣠⡟⠀⠈⠙⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⠁⠀⠀⢽⡄"
              "⠀⠀⡿⠀⠀⠀⠀⠀⠉⠷⣄⣀⣤⠤⠤⠤⠤⢤⣷⡀⠙⢷⡄⠀⠀⠀⠀⣠⠞⠉⠀⠀⠀⠀⠀⠈⡇"
              "⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠉⠳⣄⠀⠀⠀⠀⠀⠈⠁⠀⠀⠹⣦⠀⣠⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⡗"
              "⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣏"
              "⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇"
              "⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠂"
              "⠀⢿⠀⠀⠀⠀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⡀⠀⠀⠀⠀⠀⣸⠇⠀"
              "⠀⠘⣇⠀⠀⠀⠀⠉⠉⠛⠛⢿⣶⣦⠀⠀⠀⠀⠀⠀⢴⣾⣟⣛⡋⠋⠉⠉⠁⠀⠀⠀⠀⣴⠏⠀⠀"
              "⢀⣀⠙⢷⡄⠀⠀⣀⣤⣶⣾⠿⠋⠁⠀⢴⠶⠶⠄⠀⠀⠉⠙⠻⠿⣿⣷⣶⡄⠀⠀⡴⠾⠛⠛⣹⠇"
              "⢸⡍⠉⠉⠉⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⣬⠷⣆⣠⡤⠄⢀⣤⠞⠁⠀"
              "⠈⠻⣆⡀⠶⢻⣇⡴⠖⠀⠀⠀⣴⡀⣀⡴⠚⠳⠦⣤⣤⠾⠀⠀⠀⠀⠀⠘⠟⠋⠀⠀⠀⢻⣄⠀⠀"
              "⠀⠀⣼⠃⠀⠀⠉⠁⠀⠀⠀⠀⠈⠉⢻⡆⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀"
              "⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⣀⡿⠧⠿⠿⠟⠀⠀"
              "⠀⣾⡴⠖⠛⠳⢦⣿⣶⣄⣀⠀⠀⠀⠀⠘⢷⣀⠀⣸⠃⠀⠀⠀⣀⣀⣤⠶⠚⠉⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⠈⠻⠦⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠹⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⢀⡴⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡄⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⢲⡗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠋⠀⠀⠀⠀⠀⠀⠀"
              ""
              "this is a read-only buffer, sorry"
            ];
          }
        ];

        #theme = "dashboard";
      };

      #coq-nvim = {
      #  enable = true;
      #  installArtifacts = true;
      #  settings.auto_start = "shut-up";
      #};

      cmp.enable = true;

      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-treesitter.enable = true;

      fidget.enable = true;

      #cursorline = {
      #  enable = true;
      #  cursorline.enable = false;
      #  cursorword.enable = true;
      #};

      lualine = {
        enable = true;

        settings = {
          sections = {
            lualine_x = [
              "searchcount"
              "filetype"
            ];
          };

          options = {
            globalstatus = true;

            sectionSeparators = {
              left = "";
              right = "";
            };
            componentSeparators = {
              left = "";
              right = "";
            };
          };
        };
      };
    };
  };
}
