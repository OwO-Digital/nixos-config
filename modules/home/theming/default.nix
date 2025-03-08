{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.owo.theming;
in
{
  options.owo.theming = {
    prefered-scheme = mkOption {
      type = with types; (enum [ "light" "dark" ]);
      description = "Prefered system colour scheme";
    };
  };

  config = {
    owo.theming.prefered-scheme = mkDefault "dark";

    dconf.settings =
      let
        color-scheme = if
          cfg.prefered-scheme == "dark"
        then
          "prefer-dark"
        else
          "prefer-light";
      in
      {
        "org/gnome/desktop/interface" = {
          inherit color-scheme;
        };
        "org/freedesktop/interface" = {
          inherit color-scheme;
        };
      };
  };
}