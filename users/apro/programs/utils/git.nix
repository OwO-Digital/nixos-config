{
	config,
	...
}: {
	programs.git = {
		enable = true;
		userName = "Aproxia-dev";
		userEmail = "apro@r4ilax.eu";
		extraConfig = {
			safe = {
				directory = [ "/etc/nixos" ];
			};
		};
	};
}
