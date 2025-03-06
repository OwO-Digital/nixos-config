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
  };

  config = {
    programs.gamemode = mkIf cfg.gamemode {
      enable = true;
      enableRenice = mkDefault true;
    };

    services.joycond.enable = mkDefault cfg.joycond;

    environment.systemPackages =
      optional cfg.overlayConfigGUI pkgs.goverlay
      ++ optional cfg.overlays.mangohud pkgs.mangohud
      ++ optional cfg.overlays.vkbasalt pkgs.vkbasalt
      ++ optional cfg.protonup pkgs.protonup-qt
      ++ optional cfg.sgdboop pkgs.nur.repos.bandithedoge.sgdboop-bin;
  };
}
