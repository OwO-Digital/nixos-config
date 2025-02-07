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

      remotePlay.openFirewall = mkDefault true;
      localNetworkGameTransfers.openFirewall = mkDefault true;

      # makes Steam Input and such behave better under Wayland
      extest.enable = true;

      protontricks.enable = mkDefault true;
      gamescopeSession.enable = mkDefault true;
    };

    modules.desktop.gaming.utils = {
      protonup = mkDefault true;

      # both gamemode and mangohud will have to be enabled manually per game
      gamemode = mkDefault true;
      overlays.mangohud = mkDefault true;

      # SteamGridDB helper
      sgdboop = mkDefault true;
    };

    environment
    .sessionVariables
    .STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
