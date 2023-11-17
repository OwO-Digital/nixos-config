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
        extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" ];
        homeMode = "755";
        initialPassword = "gay";
      })
      cfg;

  homeCfg =
    mapAttrs
      (
        n: v:
          let
            dir = toString ../users/${n};

            mkFontconfigConf = conf: ''
              <?xml version='1.0'?>

              <!-- Generated by Home Manager. -->

              <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
              <fontconfig>
              ${conf}
              </fontconfig>
              				'';

            genDefaultFont = fonts: name:
              optionalString (fonts != [ ]) ''
                	<alias binding="same">
                		<family>${name}</family>
                		<prefer>
                		${concatStringsSep "\n\t\t\t"
                			(map (font: "<family>${font}</family>") fonts) }
                		</prefer>
                	</alias>
                				'';
          in
          {
            home = {
              username = n;
              homeDirectory = "/home/${n}";
              stateVersion = "22.11";
              file.".face".source = "${dir}/avatar.png";
            };
            programs.home-manager.enable = true;
            xdg.configFile."fontconfig/conf.d/52-hm-default-fonts.conf".text = mkFontconfigConf ''
              <!-- Default fonts -->
              ${genDefaultFont v.fc.defaultFonts.sansSerif "sans-serif"}
              ${genDefaultFont v.fc.defaultFonts.serif "serif"}
              ${genDefaultFont v.fc.defaultFonts.monospace "monospace"}
              ${genDefaultFont v.fc.defaultFonts.emoji "emoji"}
              				'';
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
        desc = "Emily Shirley";
        modules = [ ];
        fc = {
          # `fonts` takes a list of packages
          fonts = with pkgs; [ maple-mono roboto cozette twemoji-color-font noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif noto-fonts-emoji-blob-bin material-design-icons ];
          # `nerd-fonts.override` takes a list of strings
          nerd-fonts = [ "Iosevka" "JetBrainsMono" ];
          defaultFonts = {
            monospace = [ "Iosevka Nerd Font" "Cozette" ];
            sansSerif =
              [ "Roboto Condensed" ]
              ++ map (v: "Noto Sans CJK ${v}") [ "SC" "TC" "HK" "JP" "KR" ];
            serif =
              [ "Noto Serif" ]
              ++ map (v: "Noto Serif CJK ${v}") [ "SC" "TC" "HK" "JP" "KR" ];
            emoji = [ "Blobmoji" ];
          };
        };
      };
      octelly = {
        desc = "Eli Štefků";
        modules = [ ];
        fc = {
          # `fonts` takes a list of packages
          fonts = with pkgs; [
            roboto
            twemoji-color-font
            noto-fonts
            noto-fonts-cjk-sans
            maple-mono-NF
          ];
          # `nerd-fonts.override` takes a list of strings
          nerd-fonts = [ ];
          defaultFonts = {
            monospace = [ "MapleMonoNF" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
            emoji = [ "Twemoji" ];
          };
        };
      };
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = homeCfg;
  };

  config.users = {
    users = nixosCfg;
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };
}
