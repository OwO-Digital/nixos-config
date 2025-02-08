{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.emulation;
in {
  options.modules.desktop.gaming.emulation = {
    enable = mkEnableOption "the emulation module";
    switch = {
      ryujinx = mkEnableOption "Nintendo Switch (Ryujinx)";
    };
    gamecube = mkEnableOption "Nintendo GameCube";
    wii = mkEnableOption "Nintendo Wii";

    primehack = mkEnableOption "Metroid Prime GCN/Wii mouse keyboard hack";
  };

  config = mkIf cfg.enable {

    # some emulators support gamemode natively
    modules.desktop.gaming.utils.gamemode = mkDefault true;

    environment.systemPackages = [ ]
      ++ optional cfg.switch.ryujinx pkgs.ryujinx
      ++ optional (cfg.gamecube || cfg.wii) pkgs.dolphin-emu
      ++ optional cfg.primehack pkgs.dolphin-emu-primehack;
  };
}
