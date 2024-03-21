{ inputs, ... }:

let theme = import ../misc/themes/everblush/cols.nix; in

final: prev:
{
	everblush = {
		phocus = inputs.f2k.packages.x86_64-linux.phocus-modified.override {
			colors = with theme; {
				base00 = "${dbg}";
				base01 = "${bg}";
				base02 = "${abg}";
				base03 = "${lbg}";
				base04 = "${mg}";
				base05 = "lol lmao"; # these literally don't do anything
				base06 = "lol lmao"; # these literally don't do anything
				base07 = "lol lmao"; # these literally don't do anything
				base08 = "${c1}";
				base09 = "fab387";
				base0A = "${c3}";
				base0B = "${c2}";
				base0C = "${c6}";
				base0D = "${c4}";
				base0E = "f5c2e7";
				base0F = "${c5}";
			};

			primary   = theme.pri;
			secondary = theme.sec;
		};
		vscode-theme = prev.vscode-utils.extensionFromVscodeMarketplace {
				name = "Everblush";
				publisher = "mangeshrex";
				version = "0.1.1";
				sha256 = "hqRf3BGQMwFEpOMzpELMKmjS1eg4yPqgTiHQEwi7RUw=";
		};
	};
}
