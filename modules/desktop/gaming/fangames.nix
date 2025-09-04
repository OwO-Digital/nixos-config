{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.fangames;
in {
  options.modules.desktop.gaming.fangames = {
    srb2 = mkEnableOption "Sonic Robo Blast 2";
    srb2kart = mkEnableOption "Sonic Robo Blask 2 Kart";
    ringracers = mkEnableOption "Dr. Robotnik's Ring Racers";
  };

  config = {
    environment.systemPackages = with pkgs;
      optional cfg.srb2 srb2
      ++ optional cfg.srb2kart srb2kart
      ++ optional cfg.ringracers ringracers;
  };
}
