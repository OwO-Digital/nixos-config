{ config
, pkgs
, ...
}: {
	programs.zsh = {
		enable = true;
		autocd = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		enableCompletion = true;
		dotDir = ".config/zsh";

		shellAliases = {
			"ls" = "exa --icons";
			"l" = "ls";
			"ll" = "ls -l";
			"la" = "ls -a";
			"lla" = "ls -la";
			"lt" = "ls --tree";
			"lta" = "ls --tree -a";
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

			"shutdown" = "shutdown -h now";
			"reboot" = "shutdown -r now";
			"suspend" = "systemctl suspend";

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

		initExtra = ''
			setopt autocd extendedglob nomatch
			unsetopt beep notify
			bindkey -e
			# End of lines configured by zsh-newuser-install
			# The following lines were added by compinstall
			zstyle :compinstall filename "/home/apro/.config/zsh/.zshrc"

			autoload -Uz compinit
			compinit
			# End of lines added by compinstall

			zstyle ":completion:*" menu select
			# Auto complete with case insenstivity
			zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"

			export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
			export SUDO_PROMPT=$'[\033[35m%u\033[0m] passwd: '

			bindkey "^[[1;5D" backward-word
			bindkey "^[[1;5C" forward-word
			bindkey "^[[3~" delete-char

			CASE_SENSITIVE="false"

			function mkcd() { mkdir -p $1; cd $1; }
			function command_not_found_handler() { printf "\033[31mError\033[0m: Command '\033[31;1;5m%s\033[0m' not found.\n" "$0"; return 127; }
		'';

		history = {
			expireDuplicatesFirst = true;
			save = 1000;
			share = true;
			extended = true;
			path = "/home/apro/.config/zsh/histfile";
		};

		plugins = [
			{
				name = "zsh-nix-shell";
				file = "nix-shell.plugin.zsh";
				src = pkgs.fetchFromGitHub {
					owner = "chisui";
					repo = "zsh-nix-shell";
					rev = "v0.5.0";
					sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
				};
			}
		];
	};
}
