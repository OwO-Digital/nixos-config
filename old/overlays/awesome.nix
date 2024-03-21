{ inputs, ... }:

final: prev: {
	awesome = prev.awesome.override { lua = prev.luajit; };
	awesome-git = prev.awesome-git.override { lua = prev.luajit; };
}
