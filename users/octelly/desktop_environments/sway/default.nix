{ config
, ...
}: {
  xdg.configFile.sway.source = ./config;
  xdg.configFile.waybar.source = ./waybar;

  wayland.windowManager.sway = {
    systemd.enable = false;
  };
}
