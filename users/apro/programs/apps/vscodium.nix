{ config, pkgs, lib, ... }: {

	programs.vscode = {
		enable = true;
		package = pkgs.master.vscodium;

		userSettings = {
			editor = {
				fontFamily = "'Iosevka Nerd Font'";
				fontLigatures = "'ss14'";
				cursorBlinking = "smooth";
				cursorSmoothCaretAnimation = "on";
				insertSpaces = false;
				detectIndentation = false;
				tabSize = 4;
				minimap.enabled = false;
				renderWhitespace = "none";
			};

			terminal.integrated = {
				cursorStyle = "underline";
				cursorWidth = 2;
				fontFamily = "Iosevka Nerd Font";
				tabs.defaultIcon = "heart-filled";
			};

			workbench = {
				colorTheme = "Everblush";
				productIconTheme = "material-product-icons";
				iconTheme = "file-icons";
			};

			window = {
				menuBarVisibility = "compact";
				zoomLevel = 1;
			};

			nix.serverPath = "nil";
			git.confirmSync = false;
			extensions.autoCheckUpdates = true;
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
			eamodio.gitlens
			oderwat.indent-rainbow
		])
		++ (with pkgs.master.vscode-extensions; [
			ms-python.python
		])
		++ (with pkgs.everblush; [
			vscode-theme
		]);
	};
}
