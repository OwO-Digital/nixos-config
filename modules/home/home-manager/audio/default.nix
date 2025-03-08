{lib, config, ...}:
with lib;
let
  cfg = config.owo.audio;
 in {
  options.owo.audio = {
    wireplumber.disableHandsFree = mkEnableOption "HSP/HFP bluetooth profile block";
  };

  # https://wiki.archlinux.org/title/bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
  config.xdg.configFile.wireplumberDisableHandsfree = mkIf cfg.wireplumber.disableHandsFree {
    target = ".config/wireplumber/wireplumber.conf.d/50-wireplumberDisableHandsfree.conf";
    text = ''
      monitor.bluez.rules = [
        {
          matches = [
            {
              device.name = "~bluez_card.*";
            }
          ];
          actions = {
            update-props = {
              bluez5.auto-connect = [ "a2dp_sink" ];
              bluez5.hw-volume = [ "a2dp_sink" ];
            };
          };
        }
      ];
      monitor.bluez.properties = {
        bluez5.roles = [ "a2dp_sink" ];
        bluez5.hfphsp-backend = "none";
      };
    '';
  };
}