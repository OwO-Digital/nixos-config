{ inputs, ... }:

final: prev:
{
	apro = {
		st = prev.st.overrideAttrs (old: rec {
			src = prev.fetchFromGitHub {
				owner = "Aproxia-dev";
				repo = "st-flexipatch";
				rev = "98cb137c116a997c70bdf6a49ca0a5ef463d9ff3";
        		sha256 = "1j0spdlqmi8q6ghxg2b095r470hdfmmpspr5wmqgj431cp2cz5v9";
			};

			buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
		});
	};
}