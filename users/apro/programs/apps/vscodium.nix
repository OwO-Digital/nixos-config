{ config, pkgs, lib, ... }: {

	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;

		userSettings = {
			editor = {
				fontFamily = "'Iosevka NF'";
				fontLigatures = "'ss14'";
				cursorBlinking = "smooth";
				cursorSmoothCaretAnimation = "on";
				insertSpaces = false;
				detectIndentation = false;
				tabSize = 4;
				minimap.enabled = false;
				renderWhitespace = "none";
				formatOnSave = true;
			};

			terminal.integrated = {
				cursorStyle = "underline";
				cursorWidth = 2;
				fontFamily = "Iosevka NF";
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

		extensions = (with pkgs.open-vsx; [
			# vim motions (requirement ‼️)
			vscodevim.vim

			# themes
			catppuccin.catppuccin-vsc
			mangeshrex.everblush

			# icons
			pkief.material-product-icons
			file-icons.file-icons

			# languages and formatting
			editorconfig.editorconfig
			ziglang.vscode-zig
			rust-lang.rust
			rust-lang.rust-analyzer
			llvm-vs-code-extensions.vscode-clangd
			sumneko.lua
			ms-python.python
			ms-pyright.pyright
			bbenoist.nix
			arrterian.nix-env-selector
			pinage404.nix-extension-pack
			jnoortheen.nix-ide
			bungcip.better-toml
			svelte.svelte-vscode

			# git
			eamodio.gitlens
			github.vscode-pull-request-github

			# extra features
			mkhl.direnv
			oderwat.indent-rainbow
			manuel-underscore.figura
		])
		++ (with pkgs.vscode-marketplace; [

			# leftover language support
			vgalaktionov.moonscript
			tnze.snbt

			# github
			github.remotehub
		]);
	};
}
