{ lib, config, ... }:
let
  cfg = config.octelly.shell;
in
with lib; {
  options.octelly.shell =
    {
      enable = mkEnableOption "Evaluate Octelly's shell settings";
      shell = mkOption { default = cfg.enable; };
      cli = {
        enable = mkOption {
          default = cfg.enable;
          description = "Enable default CLI apps";
        };
        ranger = {
          enable = mkOption {
            default = cfg.cli.enable;
            description = "Enable ranger";
          };
        };
      };
    };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = mkDefault cfg.shell;
    };
    programs.ranger = mkIf cfg.cli.ranger.enable {
      enable = true;
    };
  };
}
