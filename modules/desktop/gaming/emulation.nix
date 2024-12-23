{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.gaming.emulation;
in {
  options.modules.desktop.gaming.emulation = {
    enable = mkEnableOption "enable the emulation module";
    switch = mkEnableOption "Nintendo Switch";
  };

  config = mkIf cfg.enable {

    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    environment.systemPackages = with pkgs; [
      # helpful overlays and such
      mangohud
      vkbasalt
      # a configurator for them
      goverlay
    ]
      ++ optional cfg.switch pkgs.ryujinx;
  };
}
