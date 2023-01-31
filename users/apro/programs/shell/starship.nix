{
	config,
	...
}: {
	programs.starship = {
		enable = true;
		settings = {

			add_newline = false;
			line_break.disabled = true;
			cmd_duration = {
				min_time = 400;
				show_milliseconds = false;
				style = "bold blue";
			};
			directory = {
				style = "bold purple";
				truncation_symbol = ".../";
			};
			character = {
				success_symbol = "[](bold green)";
				error_symbol = "[](bold red)";
				vicmd_symbol = "[](bold blue)";
			};
			hostname = {
    			ssh_only = true;
    			format = "[$hostname](bold blue) ";
    			disabled = false;
  			};
		};
	};
}