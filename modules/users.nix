{ config
, pkgs
, lib
, inputs
, system
, ...
}:
with builtins;
with lib; let
  cfg = config.modules.users;

  nixosCfg =
    mapAttrs
      (n: v: {
        description = v.desc;
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ]
          # WebDAV mounts for regular users
          ++ lib.optional config.services.davfs2.enable config.services.davfs2.davGroup
          # ADB
          ++ lib.optional config.programs.adb.enable "adbusers"
          # Docker
          ++ lib.optional config.virtualisation.docker.enable "docker"
          # i2c
          ++ lib.optional config.hardware.i2c.enable config.hardware.i2c.group
          # wireshonk
          ++ lib.optional config.programs.wireshark.enable "wireshark";
        homeMode = "755";
        initialPassword = "gay";
        shell = v.shell or config.users.defaultUserShell;
      })
      cfg;

  homeCfg =
    mapAttrs
      (
        n: v:
          let
            dir = toString ../users/${n};
          in
          {
            home = rec {
              username = n;
              homeDirectory = "/home/${n}";
              stateVersion = "22.11";
              file.".face".source = "${dir}/avatar.png";
              file.".directory".text = ''
                [Desktop Entry]
                Icon=${homeDirectory}/.face
              '';
            };
            programs.home-manager.enable = true;
            fonts.fontconfig = {
              enable = true;
              defaultFonts = {
                sansSerif = v.fc.defaultFonts.sansSerif;
                serif = v.fc.defaultFonts.serif;
                monospace = v.fc.defaultFonts.monospace;
                emoji = v.fc.defaultFonts.emoji;
              };
            };
            imports =
              [
                dir
              ]
              ++ v.modules;
          }
      )
      cfg;
in
{
  options.modules.users = mkOption {
    type = types.attrs;
    default = {
      apro = {
        desc = "Emi Pikner";
        modules = [ ];
        shell = pkgs.fish;
        fc = {
          # `fonts` takes a list of packages
          fonts = with pkgs; [
            maple-mono.NF
            cozette
            atkinson-hyperlegible-next
            roboto
            twemoji-color-font
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-emoji-blob-bin
            material-design-icons
          ];
          # list of pkgs.nerd-fonts attributes
          nerd-fonts = [ "iosevka" "jetbrains-mono" ];
          defaultFonts = {
            monospace = [ "Maple Mono NF" "Iosevka Nerd Font" "Cozette" ];
            sansSerif =
              [ "Atkinson Hyperlegible Next" ]
              ++ map (v: "Noto Sans CJK ${v}") [ "SC" "TC" "HK" "JP" "KR" ];
            serif =
              [ "Noto Serif" ]
              ++ map (v: "Noto Serif CJK ${v}") [ "SC" "TC" "HK" "JP" "KR" ];
            emoji = [ "Blobmoji" "Twitter Color Emoji" ];
          };
        };
      };
      octelly = {
        desc = "Eliška Štefková";
        modules = [ ];
        fc = {
          # `fonts` takes a list of packages
          fonts = with pkgs; [
            roboto
            twitter-color-emoji
            noto-fonts
            noto-fonts-cjk-sans
            maple-mono.NF
          ];
          # list of pkgs.nerd-fonts attributes
          nerd-fonts = [ ];
          defaultFonts = {
            monospace = [ "Maple Mono NF" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
            emoji = [ "Twitter Color Emoji" ];
          };
        };
        shell = pkgs.nushell;
      };
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs system; nixConfig = config; };
    sharedModules = [
      #inputs.anyrun.homeManagerModules.default
      #inputs.hyprland.homeManagerModules.default
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.nixvim.homeModules.nixvim
      inputs.niri.homeModules.niri
      ../home/squeezelite.nix
    ];
    users = homeCfg;
  };

  config.users = {
    users = nixosCfg;
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };
}
