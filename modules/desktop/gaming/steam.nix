{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      # wayland thing
      extest.enable = true;

      protontricks.enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    environment = {
      sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

      systemPackages = with pkgs; [
        protonup-qt

        # helpful overlays and such
        mangohud
        vkbasalt
        # a configurator for them
        goverlay
      ];
    };
  };
}
