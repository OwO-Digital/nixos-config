{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.ports;
in {
  options.modules.desktop.gaming.ports = {
    enable = mkEnableOption "the emulation module";
    zelda = {
      majora = mkEnableOption "The Legend of Zelda: Majora's Mask";
      ocarina = mkEnableOption "The Legend of Zelda: Ocarina of Time";
    };
    mario = {
      sixtyfour = mkEnableOption "Super Mario 64";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      optional cfg.zelda.majora pkgs._2ship2harkinian
      ++ optional cfg.zelda.ocarina pkgs.shipwright
      ++ optional cfg.mario.sixtyfour pkgs.sm64ex-coop;
  };
}
