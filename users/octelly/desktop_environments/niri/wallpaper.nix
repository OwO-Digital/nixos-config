{ pkgs, ... }:
let
  wpaper = "${pkgs.wpaperd}/bin";
  wpaperd = "${wpaper}/wpaperd";
  wpaperctl = "${wpaper}/wpaperctl";
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ wpaperd "-d" ]; }
  ];

  xdg.configFile."wpaperd/config.toml".source = pkgs.writers.writeTOML "config.toml" {
    default = {
      path = "${pkgs.octelly-wallpapers}";
      duration = "1m";
      sorting = "random";
      mode = "center";
    };
    default.transition.glitch-displace = { };
  };
}
