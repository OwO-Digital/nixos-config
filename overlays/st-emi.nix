{ inputs, ... }:

final: prev:
{
	st-emi = prev.st.overrideAttrs (old: rec {
		src = builtins.fetchTarball {
			url = "https://github.com/Aproxia-dev/st-flexipatch/archive/master.tar.gz";
			sha256 = "11v20i2rmsz63z4rjzswlac9i9j274rn327jp1v6jnpk9bgw8g95";
		};

  		buildInputs = old.buildInputs ++ [ prev.harfbuzz prev.imlib2 prev.gd ];
	});
}
