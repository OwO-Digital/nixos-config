{
	config,
	pkgs,
	...
}: {
	programs.discocss = {
		enable = true;
		css = import ../../etc/discord-css.nix;
		discordAlias = true;
		discordPackage = pkgs.discord.override {
			withOpenASAR = true;
		};
	};
}
