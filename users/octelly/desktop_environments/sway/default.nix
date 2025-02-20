{ _ }:
{
  xdg.configFile = {
    sway.source = ./config;
    waybar.source = ./waybar;
    "swaync/config.json".text = builtins.toJSON {
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
  };

  wayland.windowManager.sway = {
    #systemd.enable = false;
  };
}
