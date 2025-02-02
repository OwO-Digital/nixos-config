
{ config, pkgs, lib, inputs, system, ... }:

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
  isSteamEnabled = config.modules.desktop.gaming.steam.enable;
in {
  options.modules.desktop.gaming.utils = {
    overlayConfigGUI = mkEnableDefault
      "goverlay - a configurator for game overlays"
      (anyTrue (attrsets.attrValues cfg.overlays));
    
    overlays = {
      mangohud = mkEnableOption "MangoHUD - FPS counter";
      vkbasalt = mkEnableOption "vkbasalt - shaders";
    };

    protonup = mkEnableOption "protonup-qt - GUI manager for compatibility tools";

    gamemode = mkEnableOption "gamemode for extra performance during games";
  };

  config = {
    programs.gamemode = mkIf cfg.gamemode {
      enable = true;
      enableRenice = mkDefault true;
    };

    environment.systemPackages = []
      ++ optional cfg.overlayConfigGUI pkgs.goverlay
      ++ optional cfg.overlays.mangohud pkgs.mangohud
      ++ optional cfg.overlays.vkbasalt pkgs.vkbasalt
      ++ optional cfg.protonup pkgs.protonup-qt;
  };
}