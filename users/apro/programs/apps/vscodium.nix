{ config, pkgs, lib, ... }: {

	programs.vscode = {
		enable = true;
		package = pkgs.master.vscodium;

		userSettings = {
			"editor.fontFamily" = "'Iosevka Nerd Font'";
			"editor.cursorBlinking" = "smooth";
			"editor.insertSpaces" = false;
			"editor.detectIndentation" = false;
			"editor.tabSize" = 4;
			"editor.minimap.enabled" = false;

			"terminal.integrated.cursorStyle" = "underline";
			"terminal.integrated.cursorWidth" = 2;
			"terminal.integrated.fontFamily" = "Iosevka Nerd Font";
			"terminal.integrated.tabs.defaultIcon" = "heart-filled";

			"workbench.colorTheme" = "Everblush";
			"workbench.productIconTheme" = "material-product-icons";
			"workbench.iconTheme" = "file-icons";

			"window.menuBarVisibility" = "compact";
			"window.zoomLevel" = 1;

			"nix.serverPath" = "nil";
			"git.confirmSync" = false;
		};

		extensions = (with pkgs.vscode-extensions; [
			pkief.material-product-icons
			file-icons.file-icons
			mkhl.direnv
			sumneko.lua
			vscodevim.vim
			jnoortheen.nix-ide
			catppuccin.catppuccin-vsc
			editorconfig.editorconfig
		])
		++ (with pkgs.master.vscode-extensions; [
			ms-python.python
		])
		++ (with pkgs.everblush; [
			vscode-theme
		]);
	};
}
