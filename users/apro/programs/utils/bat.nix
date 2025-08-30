{
	config,
	pkgs,
	...
}: {
	programs.bat = {
		enable = true;
		config = {
			style = "changes,numbers";
			paging = "always";
			theme = "Everblush";
			pager = "less -FR";
		};
	
		themes = {
			"Catppuccin Mocha" = {
				src = pkgs.fetchFromGitHub {
					owner = "catppuccin";
					repo = "bat";
					rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
					sha256 = "lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
				};
				file = "themes/Catppuccin Mocha.tmTheme";
			};
			Everblush = {
				src = pkgs.fetchFromGitHub {
					owner = "Everblush";
					repo = "bat";
					rev = "0e982b52373167a895f88756e071d3dfff07307f";
					sha256 = "DuHV2IjJq1F/AX/QIarJCDdzycayqPbUHK9hCCvKOcM=";
				};
				file = "Everblush.tmTheme";
			};
		};
	};
}
