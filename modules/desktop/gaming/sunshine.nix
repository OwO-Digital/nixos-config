{ config, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.sunshine;
in {
  options.modules.desktop.gaming.sunshine = {
    enable = mkEnableOption "Sunshine (Moonlight) game streaming server";
  };

  config = {
    services.sunshine = mkIf cfg.enable {
      enable = true;
      autoStart = mkDefault true;

      # potential security vulnerability
      capSysAdmin = mkDefault true;

      openFirewall = mkDefault true;

      settings.sunshine_name = mkDefault config.networking.hostName;
    };
  };
}
