{ config, lib, pkgs, ... }: {

	programs.foot = {
		enable = true;
		server.enable = true;

		settings = {
			main = {
				font      = "Iosevka Nerd Font:size=12:fontfeatures=ss14, Blobmoji:size=12";
				font-bold = "Iosevka Nerd Font:size=12:weight=bold:fontfeatures=ss14, Blobmoji:size=12";
				font-italic      = "Maple Mono NF:size=12:slant=italic:fontfeatures=cv01";
				font-bold-italic = "Maple Mono NF:size=12:weight=bold:sfontfeatures=cv01lant=italic:fontfeatures=cv01";
				pad = "12x12 center";
			};
			cursor = {
				style = "underline";
				unfocused-style = "none";
				blink = "yes";
			};
			colors = {
				background = "141b1e";
				foreground = "dadada";
				regular0   = "232a2d";
				regular1   = "e57474";
				regular2   = "8ccf7e";
				regular3   = "e5c76b";
				regular4   = "67b0e8";
				regular5   = "c47fd5";
				regular6   = "6cbfbf";
				regular7   = "b3b9b8";

				bright0    = "2d3437";
				bright1    = "ef7e7e";
				bright2    = "96d988";
				bright3    = "f4d67a";
				bright4    = "71baf2";
				bright5    = "ce89df";
				bright6    = "67cbe7";
				bright7    = "bdc3c2";
			};
		};
	};
}
