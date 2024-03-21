{ config
, ...
}: {
  xdg.configFile.sway.source = ./config;
  xdg.configFile.waybar.source = ./waybar;
  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    "control-center-layer" = "top";
    "keyboard-shortcuts" = false;
    #"layer-shell" = true;
    "widgets" = [
      "mpris"
      "title"
      "dnd"
      "notifications"
    ];
  };

  wayland.windowManager.sway = {
    #systemd.enable = false;
  };
}
