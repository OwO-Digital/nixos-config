{ config
, ...
}: {
  programs.eza = {
    enable = true;
	icons = "always";
	colors = "always";
	git = true;
	enableZshIntegration = true;
	enableFishIntegration = true;
  };
}
