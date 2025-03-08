{ pkgs, lib, config, ... }:
let
  cfg = config.octelly.programs.mpv;
in
with lib; {
  options.octelly.programs.mpv =
    {
      enable = mkEnableOption "Octelly's mpv settings";
    };

  config.programs.mpv = mkIf cfg.enable {
    enable = true;
    config = {

      # replaced by uosc
      osd-bar = false;
      border = false;

    };

    scripts = with pkgs.mpvScripts; [
      uosc # better OSD
      thumbfast # thumbnails for hover
      mpris # media controls integration
      reload # automatic reload for stuck online videos
      sponsorblock
    ];

    scriptOpts.thumbfast = {
      network = true;
    };
  };
}
