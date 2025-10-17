{ config, pkgs, lib, ... }:

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

      # FIXME: change back to unstable (primary branch for this flake)
      #        once CMake 4 builds are fixed
      #        https://github.com/NixOS/nixpkgs/issues/445447
      ++ optional cfg.ringracers stable.ringracers;
  };
}
