{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.qtile;
in {
  options.modules.desktop.qtile = {
    enable = mkEnableOption "qtile";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.qtile = {
      enable = true;

      # NOTE: no longer has any effect
      # The qtile package now provides
      # separate display sessions for both X11 and Wayland.
      # backend = "wayland";
    };
  };
}
