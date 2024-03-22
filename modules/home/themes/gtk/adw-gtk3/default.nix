{ pkgs, lib, config, ... }:
let
  cfg = config.themes.gtk.adw-gtk3;
in
with lib; {
  options.themes.gtk.adw-gtk3 =
    {
      enable = mkEnableOption "Use adw-gtk3 theme";
      scheme = mkOption {
        type = with types; (enum [ "light" "dark" ]);
        description = "Theme colour scheme";
      };
    };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      adw-gtk3
    ];

    gtk = {
      enable = true;
      theme.name =
        if cfg.scheme == "dark"
        then "adw-gtk3-dark" else "adw-gtk3-light";
    };

    dconf.settings."org/gnome/desktop/interface" = {
      "color-scheme" = mkDefault
        (if cfg.scheme == "dark"
        then "prefer-dark" else "prefer-light");
    };
  };
}
