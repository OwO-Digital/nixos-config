{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.minecraft;
in {
  options.modules.desktop.gaming.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
          #graalvmPackages.graalvm-oracle
          temurin-bin-21 # formerly adoptopenjdk (this is adoptium)
          temurin-bin-25
        ];
      })
    ];
  };
}
