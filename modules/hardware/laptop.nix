{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.laptop;
in {
  options.modules.hardware.laptop = {
    enable = mkEnableOption "laptop";
  };

  config = mkIf cfg.enable {
    warnings = ''
      modules.hardware.laptop: This module is deprecated. All laptops are different, please configure manually with the help of NixOS/nixos-hardware modules.
    '';

    modules.hardware = {
      acpi.enable = true;
      bluetooth.enable = true;
      brightness.enable = true;
    };
    environment.systemPackages = with pkgs; mkIf config.services.xserver.enable [ networkmanagerapplet ];
  };
}
