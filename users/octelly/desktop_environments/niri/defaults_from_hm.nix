{ config, lib, ... }:
{
  programs.niri.settings = {
    input = {
      keyboard.xkb = {
        layout = lib.mkDefault config.home.keyboard.layout;
        options = lib.mkDefault (lib.concatStringsSep "," config.home.keyboard.options);
      };
    };
  };
}
