{ pkgs, lib, ... }:
let
  display = ":69"; # random unique display number
in
{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [ "${lib.getExe pkgs.xwayland-satellite}" display ];
    }
  ];

  programs.niri.settings.environment = {
    "DISPLAY" = display;
  };
}
