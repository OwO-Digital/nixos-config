{ lib, ... }:
let
	inherit (lib) mkOption types;
in
rec {
  mkOpt = type: default:
    mkOption { inherit type default; };

  mkBoolOpt = default: mkOpt types.bool default;
  mkStringOpt = default: mkOpt types.str default;
  mkStrListOpt = default: mkOpt types.listOf types.lines default;
}