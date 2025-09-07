{
	config,
	pkgs,
	...
}: {
	programs = {
		hyfetch = {
			enable = true;
			settings = {
				preset = "finsexual";
				mode = "rgb";
				light_dark = "dark";
				lightness = 0.69;
				color_align.mode = "horizontal";
				backend = "fastfetch";
				distro = "nixos_small";
				pride_month_disable = false;
			};
		};
		fastfetch = {
			enable = true;
			settings = {
			  logo = {
				  source = "nixos_old_small";
				  type = "auto";
			      padding.left = 2;
			      color = {
			          "1" = "blue";
			          "2" = "blue";
			          "3" = "blue";
			          "4" = "blue";
			          "5" = "blue";
			          "6" = "blue";
			          "7" = "blue";
			          "8" = "blue";
			          "9" = "blue";
			      };
			  };
			  display = {
			    separator = "   ";
			    color = {
			        keys = "blue";
			        logo = "blue";
			        separator = "black";
			    };
			  };
			  modules = [
			    {
			        type = "command";
			        key = " ";
			        text = "hostname";
			        format = "{#blue}┌─ {#bold_white}{$USER}@{result} {#blue}─┐";
			    }
			    {
			        type = "os";
			        key =  "   ";
			        format = "{name}";
			    }
			    {
			        type = "wm";
			        key = "   ";
			        format = "{pretty-name} {version}";
			    }
			    {
			        type = "shell";
			        key = "  󰈺 ";
			        format = "{exe-name} {version}";
			    }
			    {
			        type = "terminal";
			        key = "   ";
			        format = "{exe-name}";
			    }
			    {
			        type = "packages";
			        key = "  󰏗 ";
			        format = "{all}";
			    }
			    {
			        type = "command";
					key = " ";
			        text = "printf '%*s' \"$(printf '%s' \"$(whoami)@$(hostname)    \" | wc -m)\" '' | sed 's/ /─/g'";
			        format = "{#blue}└{result}┘";
			    }
			    {
			        type = "custom";
			        format = "{#bold_black}  {#bold_red}  {#bold_green}  {#bold_yellow}  {#bold_black}|  {#bold_blue}  {#bold_magenta}  {#bold_cyan}  {#bold_white}  ";
			    }
			  ];
			};
		};
	};
}
