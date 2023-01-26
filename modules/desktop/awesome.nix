{ config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.ext;
let cfg = config.modules.desktop.awesomewm;
in {
	options.modules.desktop.awesomewm = {
		enable = mkBoolOpt false;
		package = mkStringOpt "awesome";
	};

	config = mkIf cfg.enable {
		nixpkgs.overlays = [
			(final: prev: {
				awesome = prev.awesome.override { lua = prev.luajit; };
				awesome-git = prev.awesome-git.override { lua = prev.luajit; };
			})
		];

		environment.systemPackages = with pkgs; [ luajit ];

		services.xserver = {
			windowManager.awesome = {
				enable = true;
				package = pkgs.${options.modules.desktop.awesomewm.package};
			};

			displayManager.lightdm.enable = true;
		};
	};
}