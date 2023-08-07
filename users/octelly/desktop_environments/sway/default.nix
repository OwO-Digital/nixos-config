{ config
, ...
}: {
  xdg.configFile.sway.source = ./config;
  xdg.configFile.waybar.source = ./waybar;
}
