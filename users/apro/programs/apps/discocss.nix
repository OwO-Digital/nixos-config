{
	config,
	pkgs,
	...
}: {
	programs.discocss = {
		enable = true;
		css = builtins.readFile ../../../../misc/themes/everblush/discord.css;
		discordAlias = true;
		discordPackage = pkgs.discord.override {
			withOpenASAR = true;
		};
	};
}
