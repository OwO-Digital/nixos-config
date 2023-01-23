final: prev:
{
	ncmpcpp-git = prev.ncmpcpp.overrideAttrs (old: rec {
		src = prev.fetchFromGitHub {
			owner = "ncmpcpp";
			repo = "ncmpcpp";
			rev = "417d7172e5587f4302f92ea6377268dca7f726ad";
			sha256 = "LRf/iWxRO9zX+MZxIQbscslicaWzN7kokzJLUVg7T38=";
		};

		nativeBuildInputs = old.nativeBuildInputs ++ [ prev.autoconf prev.automake prev.libtool ];

		preConfigure = "./autogen.sh";
	});
}