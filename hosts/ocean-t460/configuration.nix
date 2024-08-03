{ config, pkgs, ... }: {

  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        olympus.enable = false;
        minecraft.enable = true;
      };
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
      sway.enable = true;
      qtile.enable = true;
      hyprland.enable = false;
    };
    hardware.laptop.enable = true;
    system = {
      sound.enable = true;
      xorg = {
        enable = true;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 25565 ];
  #nix.buildMachines = [{
  #  hostName = "192.168.1.137";
  #  system = "x86_64-linux";
  #}];
  #nix.distributedBuilds = true;

  #nix.extraOptions = ''
  #  builders-use-substitutes = true
  #'';

  #services.desktopManager.cosmic.enable = true;
}
