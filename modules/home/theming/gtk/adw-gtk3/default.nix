{ pkgs, lib, config, ... }:
let
  cfg = config.owo.theming.gtk.adw-gtk3;
in
with lib; {
  options.owo.theming.gtk.adw-gtk3 =
    {
      enable = mkEnableOption "Use adw-gtk3 theme";
      scheme = mkOption {
        type = with types; (enum [ "light" "dark" ]);
        description = "Theme colour scheme";
      };
    };

  config = mkIf cfg.enable {
    owo.theming.gtk.adw-gtk3.scheme =
      mkDefault config.owo.theming.prefered-scheme;

    home.packages = with pkgs; [
      adw-gtk3
    ];

    gtk = {
      enable = true;
      theme.name =
        if cfg.scheme == "dark"
        then "adw-gtk3-dark" else "adw-gtk3-light";
    };
  };
}
