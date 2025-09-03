{
	config,
	...
}: {
	programs.starship = {
		enable = true;
		enableTransience = true;
		settings = {

			add_newline = false;
			format = ''
$username$hostname$localip$shlvl$singularity$kubernetes$nats$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package(via $bun$c$cmake$cobol$cpp$crystal$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$gradle$haskell$haxe$helm$java$julia$kotlin$lua$mojo$nim$nodejs$ocaml$odin$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig)(using $buf$guix_shell$nix_shell$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$direnv)$env_var$mise$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$netns$os$shell$character
			'';
			profiles.transient = ''
$character\\
			'';
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
				success_symbol = "[󰣐](bold green)";
				error_symbol = "[󰋔](bold red)";
				vicmd_symbol = "[](bold blue)";
			};
			hostname = {
				ssh_only = true;
				format = "[$hostname](bold blue) ";
				disabled = false;
			};
			nix_shell = {
				symbol = "❄️";
				format = "[$symbol (\\($name $state\\))]($style) ";
				pure_msg = "📫";
				impure_msg = "📬";
			};
			bun.format = "[$symbol]($style)";
			buf.format = "[$symbol]($style)";
			cmake.format = "[$symbol]($style)";
			cobol.format = "[$symbol]($style)";
			crystal.format = "[$symbol]($style)";
			daml.format = "[$symbol]($style)";
			dart.format = "[$symbol]($style)";
			deno.format = "[$symbol]($style)";
			dotnet.format = "[$symbol(🎯 $tfm )]($style)";
			elixir.format = "[$symbol]($style)";
			elm.format = "[$symbol]($style)";
			erlang.format = "[$symbol]($style)";
			fennel.format = "[$symbol]($style)";
			gleam.format = "[$symbol]($style)";
			golang.format = "[$symbol]($style)";
			gradle.format = "[$symbol]($style)";
			haxe.format = "[$symbol]($style)";
			helm.format = "[$symbol]($style)";
			java.format = "[$symbol]($style)";
			julia.format = "[$symbol]($style)";
			kotlin.format = "[$symbol]($style)";
			lua.format = "[$symbol]($style)";
			meson.format = "[$symbol]($style)";
			nim.format = "[$symbol]($style)";
			nodejs.format = "[$symbol]($style)";
			ocaml.format = "[$symbol(\\($switch_indicator$switch_name\\) )]($style)";
			opa.format = "[$symbol]($style)";
			perl.format = "[$symbol]($style)";
			pixi.format = "[$symbol($environment )]($style)";
			php.format = "[$symbol]($style)";
			pulumi.format = "[$symbol$stack]($style)";
			purescript.format = "[$symbol]($style)";
			python.format = "[$symbol]($style)";
			quarto.format = "[$symbol]($style)";
			raku.format = "[$symbol]($style)";
			red.format = "[$symbol]($style)";
			rlang.format = "[$symbol]($style)";
			ruby.format = "[$symbol]($style)";
			rust.format = "[$symbol]($style)";
			solidity.format = "[$symbol]($style)";
			typst.format = "[$symbol]($style)";
			swift.format = "[$symbol]($style)";
			vagrant.format = "[$symbol]($style)";
			vlang.format = "[$symbol]($style)";
			zig.format = "[$symbol]($style)";
		};
	};
}
