{ inputs, repoConf, ... }:

self: super:
{
	lib.ext =
		super.lib.extend (final: prev: {
			ext = import ../lib
			{ inherit inputs repoConf; lib = final; };
		});

}