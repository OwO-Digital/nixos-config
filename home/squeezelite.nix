{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services.squeezelite;

  useLocalPlayerName = (!cfg.mprisqueeze.enable) || (cfg.playerName != null);

  squeezeliteCommand = (concatStringsSep " " (
    [
      (getExe cfg.package)

      "-d"
      "all=info"
    ]
    ++ optionals (cfg.playbackTimeout != null) [ "-C" (toString cfg.playbackTimeout) ]
    ++ optionals (!useLocalPlayerName) [ "-N" "${config.xdg.dataHome}/squeezelite/player-name" ]
    ++ optionals useLocalPlayerName [
      "-n"
      (
        if cfg.mprisqueeze.enable
        then "{name}"
        else cfg.playerName
      )
    ]
    ++ optionals (cfg.mprisqueeze.enable) [ "-s" "{server}" ]
  ));

  mprisqueezeCommand = (concatStringsSep " " [
    (getExe cfg.mprisqueeze.package)
    "-p"
    cfg.playerName
    "--"
    squeezeliteCommand
  ]);
in
{
  options.services.squeezelite = {
    enable = mkEnableOption "Enable Squeezelite user service - a software Squeezebox emulator.";

    mprisqueeze = {
      enable = mkEnableOption "Use mprisqueeze to expose mpris controls.";

      package = mkOption {
        type = types.package;
        default = inputs.mprisqueeze.packages.${pkgs.system}.default;
        description = ''
          mprisqueeze package to use.
        '';
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.squeezelite-pulse;
      description = ''
        Squeezelite package to use.
      '';
    };

    wantedBy = mkOption {
      default = "default.target";
      type = types.str;
      description = ''
        Set the WantedBy value for the systemd service.
      '';
    };

    playbackTimeout = mkOption {
      default = 2;
      example = null;
      type = with types; nullOr int;
      description = ''
        Close the output device after set amount of seconds of the player being idle. Will keep the device open indefinitely if set to null.
      '';
    };

    playerName = mkOption {
      default = null;
      example = "Hello World";
      type = with types; nullOr str;
      description = ''
        Name used to refer to this player. Keep null to let the name be changed server-side.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [ ]
      ++ optional cfg.mprisqueeze.enable {
      assertion = (cfg.playerName != null);
      message = "services.squeezelite.playerName must be set when mprisqueeze is enabled";
    };

    systemd.user.services.squeezelite = {
      Unit = {
        Description = "Software Squeezebox emulator";
        Documentation = [ "man:squeezelite(1)" ]
          ++ optional cfg.mprisqueeze.enable "https://github.com/jecaro/mprisqueeze/";
        After = [
          "network.target"
          "sound.target"
        ];
      };
      Install.WantedBy = [ "graphical.target" ];
      Service = {
        ExecStart =
          if cfg.mprisqueeze.enable
          then mprisqueezeCommand
          else squeezeliteCommand;
        Restart = "on-failure";

        # Security
        CapabilityBoundingSet = [ ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        RestrictSUIDSGID = true;
        ProtectSystem = "full";
        ProtectProc = true;
      };
    };
  };
}
