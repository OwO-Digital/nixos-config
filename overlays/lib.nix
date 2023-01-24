{ inputs, ... }:

final: prev:
{
	lib = import ./lib
	{ inherit inputs nixpkgs pkgsConf home nix-hw; lib = final; };
};
