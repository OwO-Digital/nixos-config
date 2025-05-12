{ config, lib, pkgs, ... }:
let
  flameshot = lib.getExe (pkgs.flameshot.override { enableWlrSupport = true; });
in
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Control+Shift+Delete".action = spawn flameshot "gui";
  };
}
