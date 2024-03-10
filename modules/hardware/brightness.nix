{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let cfg = config.modules.hardware.brightness;
in {
  options.modules.hardware.brightness = {
    enable = mkEnableOption "brightness";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ brightnessctl ];

    # SwayOSD brightness controls don't work without this
    # See https://github.com/ErikReider/SwayOSD?tab=readme-ov-file#brightness-control
    # (it should essentially give access to `/sys/class/backlight/*/brightness` to the `video` group)
    services.udev.packages = with pkgs; [ swayosd ];
    # note: SwayOSD doesn't even give you an error message when this isn't set correctly
  };
}
