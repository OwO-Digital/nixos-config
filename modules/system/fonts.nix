{ config, pkgs, lib, inputs, system, ... }:

with builtins;
with lib;
let
	fontList = unique (flatten
	(mapAttrsToList
		(n: v: v.fc.fonts)
		config.modules.users));

	nerdFontList = unique (flatten
	(mapAttrsToList
		(n: v: v.fc.nerd-fonts)
		config.modules.users));
in {
	config.fonts.fonts =fontList ++ [ (pkgs.nerdfonts.override { fonts = nerdFontList; }) ];
}