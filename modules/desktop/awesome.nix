{ config, pkgs, lib, ... }:

with builtins;
with lib;
let cfg = config.modules.desktop.awesome;
in {
	options.modules.desktop.awesome = {
		enable = mkEnableOption "awesome";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ luajit ];

		nixpkgs.overlays = [
			(final: prev: {
				awesome = prev.awesome.override { lua = prev.luajit; };
				awesome-git = prev.awesome-git.override { lua = prev.luajit; };
			})
		];

		services.xserver = {
		  enable = true;
			windowManager.awesome = {
				enable = true;
				package = pkgs.awesome-git;
			};

			displayManager.lightdm.enable = true;
		};
	};
}
