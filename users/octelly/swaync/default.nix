{ ... }:
{
  xdg.configFile = {
    "qtile".source = ./desktop_environments/qtile;

    "swaync/config.json".text = builtins.toJSON {
      "control-center-exclusive-zone" = true;

      "positionX" = "center";
      "positionY" = "top";
      "control-center-positionX" = "none";
      "control-center-positionY" = "none";
      "control-center-margin-top" = 8;
      "control-center-margin-bottom" = 8;
      "control-center-margin-right" = 8;
      "control-center-margin-left" = 8;
      "control-center-width" = 500;
      "control-center-height" = 600;
      "fit-to-screen" = false;

      "layer" = "overlay";
      "control-center-layer" = "overlay";
      "cssPriority" = "user";

      "keyboard-shortcuts" = false;
      "widgets" = [
        "mpris"
        "title"
        "dnd"
        "notifications"
      ];
    };
    "swaync/style.css".source = ./swaync.css;
  };
}
