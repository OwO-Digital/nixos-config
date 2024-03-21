{ inputs, ... }:

final: prev:
{
	st-emi = prev.st.overrideAttrs (old: rec {
		src = builtins.fetchTarball {
			url = "https://github.com/Aproxia-dev/st-flexipatch/archive/main.tar.gz";
			sha256 = "0aw78ry6bwxjz9x0q75s2r9vf84bm0grhf50q9xhx8s2s2k82m6p";
		};

  		buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
	});
}
