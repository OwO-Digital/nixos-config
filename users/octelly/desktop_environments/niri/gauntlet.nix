{ config, inputs, lib, pkgs, ... }:
let
  gauntlet = lib.getExe inputs.gauntlet.packages.${pkgs.system}.default;
in
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+r" = {
      action = spawn gauntlet "open";
      hotkey-overlay.title = "Open Gauntlet (launcher/search)";
    };
  };
  programs.niri.settings.spawn-at-startup = [
    {
      command = [ gauntlet "--minimized" ];
    }
  ];
}
