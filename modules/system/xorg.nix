{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.system.xorg;
in {
  options.modules.system.xorg = {
    enable = mkEnableOption "xorg";

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
    services.xserver = {
      enable = true;
      dpi = cfg.dpi;
      xkb.layout = cfg.layout;
      displayManager = {
        #${cfg.displayManager}.enable = true;
        #defaultSession = cfg.defaultSession;
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
        };
      };
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad = {
          middleEmulation = false;
          tapping = false;
          naturalScrolling = cfg.touchpad.naturalScrolling;
          accelProfile =
            if cfg.touchpad.acceleration then
              "adaptive" else
              "flat";
        };
      };
      xkb.extraLayouts.fck = {
        description = "Czech Programmer version of Colemak DH";
        languages = [ "en" "cs" ];
        symbolsFile = ../../misc/keymaps/fck;
      };
    };
  };
}
