{ config, pkgs, lib, ... }:

with builtins;
with lib;
let
  cfg = config.modules.desktop.gaming.emulation;
  anyTrue = list: lists.any (x: x) list;
in
{
  options.modules.desktop.gaming.emulation = {
    enable = mkEnableOption "the emulation module";

    nce = {
      pc_engine = mkEnableOption "PC Engine / TurboGrafx-16";
    };

    nintendo = {
      ds = mkEnableOption "Nintendo DS";
      gamecube = mkEnableOption "Nintendo GameCube";
      gb = mkEnableOption "GameBoy (Color)";
      gba = mkEnableOption "GameBoy Advance";
      nes = mkEnableOption "Nintendo Entertainment System / Famicom";
      snes = mkEnableOption "Super Nintendo Entertainment System / Super Famicom";
      switch = mkEnableOption "Nintendo Switch";
      wii = mkEnableOption "Nintendo Wii";

      primehack = mkEnableOption "Metroid Prime GCN/Wii mouse keyboard hack";
    };

    sony = {
      ps2 = mkEnableOption "Playstation 2";
      ps3 = mkEnableOption "Playstation 3";
      psp = mkEnableOption "Playstation Portable";
    };

    dsu_client = mkEnableOption "evdevhook2";

    retroarch_cores = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of libretro cores to install.";
      example = literalExpression ''
        with pkgs.libretro; [ ppsspp ] 
      '';
    };
  };

  config = mkIf cfg.enable {

    # some emulators support gamemode natively
    modules.desktop.gaming.utils.gamemode = mkDefault true;

    modules.desktop.gaming.utils.joycond = mkDefault cfg.nintendo.switch;

    modules.desktop.gaming.utils.rusty-psn = mkDefault cfg.sony.ps3;

    modules.desktop.gaming.emulation.retroarch_cores = with pkgs.libretro;
      optional cfg.nce.pc_engine beetle-pce
      ++ optional cfg.nintendo.ds melonds
      ++ optional cfg.nintendo.gb gambatte
      ++ optional cfg.nintendo.gba mgba
      ++ optional cfg.nintendo.nes mesen
      ++ optional cfg.nintendo.snes bsnes-hd
      ++ optional cfg.sony.psp ppsspp;

    # enable DSU client by default for emulators with support
    modules.desktop.gaming.emulation.dsu_client = mkIf
      (anyTrue (with cfg; [
        nintendo.switch
        nintendo.wii
      ]))
      (mkDefault true);

    environment.systemPackages = with pkgs;
      optional (cfg.nintendo.gamecube || cfg.nintendo.wii) dolphin-emu
      ++ optional (cfg.retroarch_cores != [ ]) (retroarch.withCores (_: cfg.retroarch_cores))
      ++ optional cfg.dsu_client evdevhook2
      ++ optional cfg.nintendo.primehack dolphin-emu-primehack
      ++ optional cfg.nintendo.switch ryubing # maintained Ryujinx fork
      ++ optional cfg.sony.ps2 pcsx2 # libretro core doesn't support RetroAchievements
      ++ optional cfg.sony.ps3 rpcs3
    ;
  };
}
