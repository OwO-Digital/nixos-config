{ config, pkgs, ... }:
let
  swaync = "${pkgs.swaynotificationcenter}/bin/swaync";
  swaync-client = "${swaync}-client";
in
{
  imports = [
    # global swaync config
    ../../swaync
  ];

  programs.niri.settings.spawn-at-startup = [
    # swaync
    {
      command = [ swaync ];
    }
  ];

  programs.niri.settings.binds = with config.lib.niri.actions; {
    # NOTE:
    # `Mod` is a special modifier that is equal to `Super` when running niri on a TTY,
    # and to `Alt` when running niri as a nested winit window
    "Mod+a".action = spawn swaync-client "-t" "-sw";
  };
}
