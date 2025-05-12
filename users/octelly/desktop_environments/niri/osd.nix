{ config, pkgs, ... }:
let
  swayosd = "${pkgs.swayosd}/bin/swayosd";
  swayosd-client = "${swayosd}-client";
  swayosd-server = "${swayosd}-server";
in
{

  programs.niri.settings.binds = with config.lib.niri.actions; let
    volume-sensitivty = 1;

    change-volume = amount:
      spawn swayosd-client "--output-volume" amount;
  in
  {
    "XF86AudioRaiseVolume" = {
      action = change-volume "+${builtins.toString volume-sensitivty}";
      hotkey-overlay.title = "Raise Volume";
    };
    "XF86AudioLowerVolume" = {
      action = change-volume "-${builtins.toString volume-sensitivty}";
      hotkey-overlay.title = "Lower Volume";
    };
  };

  programs.niri.settings.spawn-at-startup = [{ command = [ swayosd-server ]; }];
}
