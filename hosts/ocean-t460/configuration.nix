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
