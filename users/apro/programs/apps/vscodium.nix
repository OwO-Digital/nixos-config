{
	config,
	pkgs,
  lib,
	...
}: {
	programs.vscode = {
		enable = true;
		package = pkgs.master.vscodium;

    userSettings = {
    	"editor" = {
        "fontFamily" = "'Iosevka Nerd Font'";
    	  "cursorBlinking" = "smooth";
    	  "insertSpaces" = false;
    	  "detectIndentation" = false;
    	  "tabSize" = 4;
    	  "minimap.enabled" = false;
      };


    	"terminal" = {
        "integrated.cursorStyle" = "underline";
    	  "integrated.cursorWidth" = 2;
    	  "integrated.fontFamily" = "Iosevka Nerd Font";
    	  "integrated.tabs.defaultIcon" = "heart-filled";
      };

    	"workbench" = {
        "colorTheme" = "Everblush";
        "productIconTheme" = "material-product-icons";
        "iconTheme" = "file-icons";
      };

    	"window" = {
        "menuBarVisibility" = "compact";
    	  "zoomLevel" = 1;
      };

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
    ]) ++ 
    (with pkgs.master.vscode-extensions; [
        ms-python.python
    ]) ++
    (with pkgs.everblush; [
			  vscode-theme
    ]);
	};
}
