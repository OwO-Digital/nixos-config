{ config
, pkgs
, ...
}: {
	programs = {
		fish = {
			enable = true;

			shellAbbrs = {
				"l" = "ls";
				"ll" = "ls -l";
				"la" = "ls -a";
				"lla" = "ls -la";
				"lt" = "ls --tree";
				"lta" = "ls --tree -a";

				"shutdown" = "shutdown -h now";
				"reboot" = "shutdown -r now";
				"suspend" = "systemctl suspend";
			};
			shellAliases = {
				"ls" = "exa --icons";
				"cls" = "clear";
				"du" = "ncdu";
				"df" = "duf";

				"mv" = "mv -i";
				"rm" = "rm -i";
				"cp" = "cp -i";
				"grep" = "rg";
				"mkdir" = "mkdir -pv";

				"doas" = "sudo";
				"please" = "sudo";
				"pls" = "sudo";

				"bai" = "shutdown";
				"brb" = "reboot";
				"cya" = "suspend";
				"zzz" = "suspend";

				"vim" = "nvim";
				"edit" = "nvim";
				"sedit" = "sudo nvim";

				":q" = "exit";
				":wq" = "exit";
			};

			functions = {
				mkcd = {
					description = "create and change to a new directory";
					argumentNames = "directory";
					body = ''
						mkdir $argv
						cd $directory
					'';
				};

				# prompts
				fish_command_not_found.body = ''
    				echo [(set_color red)error(set_color normal)] command \"(set_color -o red)$argv[1](set_color normal)\" not found.
				'';

				starship_transient_prompt_func.body = ''
    				starship module character
				'';
			};

			interactiveShellInit = ''
				export SUDO_PROMPT="[$(set_color magenta)%u$(set_color reset)] passwd: "
				set fish_color_command green
				set fish_color_param normal
				set fish_color_comment normal --dim
				set fish_color_option cyan
				${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
  			'';
		};

		direnv.enableFishIntegration = true;
		eza.enableFishIntegration = true;
		starship = {
			enableFishIntegration = true;
			enableInteractive = true;
		};
	};
}
