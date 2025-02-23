{ config, inputs, lib, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "hyprland";
    debug = mkEnableOption "hyprland debug mode";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${system}.hyprland.override {
        debug = cfg.debug;
      };
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
  };
}
