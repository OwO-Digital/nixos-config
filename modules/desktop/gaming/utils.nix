{ config, pkgs, lib, ... }:

with builtins;
with lib;
let
  cfg = config.modules.desktop.gaming.utils;
  # mkEnableOption, but you can set the default
  mkEnableDefault = name: default: mkOption {
    inherit default;
    example = true;
    description = "Whether to enable ${name}.";
    type = types.bool;
  };
  # or operation for a list - if a single value is true, return true
  anyTrue = list: lists.any (x: x) list;
in
{
  options.modules.desktop.gaming.utils = {
    overlayConfigGUI = mkEnableDefault
      "goverlay - a configurator for game overlays"
      (anyTrue (attrsets.attrValues cfg.overlays));
    # if any of the overlays are enabled, enable the GUI

    overlays = {
      mangohud = mkEnableDefault "MangoHUD - FPS counter" false;
      vkbasalt = mkEnableDefault "vkbasalt - shaders" false;
    };

    protonup = mkEnableDefault "protonup-qt - GUI manager for compatibility tools" false;

    gamemode = mkEnableDefault "gamemode for extra performance during games" false;

    sgdboop = mkEnableDefault "SGDBoop - SteamGridDB URL handler for setting custom Steam library art" false;

    joycond = mkEnableDefault "joycond - daemon for Nintendo Switch controllers" false;

    rusty-psn = mkEnableDefault "rusty-psn - PS3 game updater" false;
  };

  config = {
    programs.gamemode = mkIf cfg.gamemode {
      enable = true;
      enableRenice = mkDefault true;
    };

    services.joycond.enable = mkDefault cfg.joycond;

    environment.systemPackages = with pkgs;
      optional cfg.overlayConfigGUI goverlay
      ++ optional cfg.overlays.mangohud mangohud
      ++ optional cfg.overlays.vkbasalt vkbasalt
      ++ optional cfg.protonup protonup-qt
      ++ optional cfg.sgdboop nur.repos.bandithedoge.sgdboop-bin
      ++ optional cfg.rusty-psn rusty-psn-gui
    ;
  };
}
