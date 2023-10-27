{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.river;
in {
  options.modules.desktop.river = {
    enable = mkEnableOption "river";
  };

  config = mkIf cfg.enable {
  	environment.systemPackages = with pkgs; [ rivercarro ];
	programs.river.enable = true;
  };
}
