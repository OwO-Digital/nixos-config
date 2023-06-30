{ config, pkgs, ... }: {

  modules = {
    desktop = {
      gaming = {
        steam.enable = true;
        olympus.enable = false;
      };
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
      sway.enable = true;
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
}
