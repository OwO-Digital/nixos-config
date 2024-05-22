{ pkgs, lib, config, ... }:
let
  cfg = config.programs.tauon;
in
with lib; {
  options.programs.tauon =
    {
      enable = mkEnableOption "Whether to enable Tauon Music Box";
      discordRpc = mkEnableOption "Enable Discord RPC feature";
    };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (if cfg.discordRpc
      then
        (tauon.override {
          withDiscordRPC = true;
        })
      else tauon)
    ];
  };
}
