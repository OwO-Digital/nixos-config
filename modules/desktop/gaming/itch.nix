{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.itch;
in {
  options.modules.desktop.gaming.itch = {
    enable = mkEnableOption "itch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ itch ];
  };
}
