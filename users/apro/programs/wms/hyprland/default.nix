{ inputs, system, ... }: {

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
  };

  imports = [
    ./settings.nix
    ./binds.nix
    ./anims.nix
    ./plugins.nix
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
