{
	config,
	pkgs,
	...
}: {
	programs.vscode = {
		enable = true;
		package = pkgs.master.vscodium;
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
		]) ++ ( with pkgs.everblush; [
			vscode-theme
		]);
	};
}
