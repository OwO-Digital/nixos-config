{ config, lib, pkgs, inputs, system, ... }: {

  programs.ghostty = {
    enable = true;
	package = inputs.ghostty.packages.${system}.default;
	
	installVimSyntax = true;
	enableBashIntegration = true;
	enableZshIntegration = true;
	enableFishIntegration = true;

	settings = {
	  font-family = [
		"Maple Mono NF"
		"Blobmoji"
	  ];
	  font-size = 11;
	  font-feature = [
	    "+calt" "+ss08" "+ss11" # ligatures
		"+cv01" # no gaps in special symbols
		"+cv02" # "+cv31" # a with a top arm
		"+cv09" "+cv42" # 7 with strikethrough
		"+zero" # dotted 0
		"+cv64" # greater/less than or equal to with straight bottom line
	  ];

	  theme = "Everblush";
	  selection-invert-fg-bg = true;
	  cursor-style = "underline";

	  window-padding-x = 12;
	  window-padding-y = 12;
	  window-decoration = "server";
	  window-theme = "ghostty";

	  shell-integration-features = [
	    "cursor"
		"sudo"
		"title"
	  ];
	};
  };
}
