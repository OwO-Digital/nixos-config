{
	config,
	pkgs,
	...
}: {
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;
		extensions = with pkgs.vscode-extensions; [
			sumneko.lua
			vscodevim.vim
			jnoortheen.nix-ide
			catppuccin.catppuccin-vsc
		];
	};
}
