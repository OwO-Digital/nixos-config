{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    programs.sway.enable = true;
    programs.sway.package = pkgs.sway.override {
      sway-unwrapped = pkgs.sway-unwrapped.overrideAttrs (old: {
        inherit (pkgs.swayfx) src pname version meta patches;
      });
    };
  };
}
