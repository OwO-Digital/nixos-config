{ lib, inputs, repoConf, ... }:
let
	inherit (lib) mkOption types;
in
rec {
  mkOpt = type: default:
    mkOption { inherit type default; };

  mkBoolOpt = default: mkOption {
    inherit default;
    type = types.bool;
    example = true;
  };

  mkStringOpt = default: mkOption {
    inherit default;
    type = types.lines;
    example = "";
  };

  mkListOfStringOpt = default: mkOption {
    inherit default;
    type = types.listOf types.lines;
    example = [ "a" "b" "c" ];
  };
}