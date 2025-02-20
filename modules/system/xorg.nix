{ config, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.system.xorg;
in {
  options.modules.system.xorg = {
    enable = mkEnableOption "xorg";

    # NOTE: I think some parts of our setup
    #       rely on LightDM I think
    #       - Octelly
    displayManager = mkOption {
      type = types.str;
      default = "lightdm";
    };

    defaultSession = mkOption {
      type = types.str;
      default = "none+awesome";
    };

    dpi = mkOption {
      type = types.int;
      default = 100;
    };

    layout = mkOption {
      type = types.str;
      default = "us";
    };

    touchpad = {
      naturalScrolling = mkOption {
        type = types.bool;
        default = true;
      };

      acceleration = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        inherit (cfg) dpi;
        enable = true;
        xkb.layout = cfg.layout;
        displayManager = {
          lightdm = {
            enable = true;
            greeters.slick.enable = true;
          };
        };

        # FIXME: this shouldn't be reliant on Xorg as it is used by Wayland too
        #        - Octelly
        xkb.extraLayouts.fck = {
          description = "Czech Programmer version of Colemak DH";
          languages = [ "en" "cs" ];
          symbolsFile = ../../misc/keymaps/fck;
        };
      };
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad = {
          inherit (cfg.touchpad) naturalScrolling;

          # FIXME: why opinionated?
          #        - Octelly
          middleEmulation = false;
          tapping = false;

          accelProfile =
            if cfg.touchpad.acceleration then
              "adaptive" else
              "flat";
        };
      };
    };
  };
}
