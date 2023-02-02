{ inputs, ... }:

final: prev:
{
	apro = {
		st = prev.st.overrideAttrs (old: rec {
			src = prev.fetchFromGitHub {
				owner = "Aproxia-dev";
				repo = "st-flexipatch";
				rev = "d7d1b63ba03e73d5042e9ea431d46b98cff57a4e";
        sha256 = "4jXJSCaBWhfS0qCkb7g34al7CsuEXkoVM7mUuIyv/r8=";
			};

			buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
		});
	};
}
