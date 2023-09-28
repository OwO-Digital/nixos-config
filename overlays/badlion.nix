{ inputs, ... }:

final: prev: {
	badlion = let
		name = "badlion";
		fname = "BadlionClient";
		src = prev.fetchurl {
			url = "https://client-updates-cdn77.badlion.net/BadlionClient";
			hash = "sha256-HqMgY9+Xnp4uSTWr//REZGv3p7ivwLX97vxGD5wqu9E=";
		};

		desktopItem = prev.makeDesktopItem {
			name = "BadlionClient";
			desktopName = "Badlion Client";
			exec = "badlion --no-sandbox";
			terminal = false;
			icon = "BadlionClient";
			startupWMClass = "Badlion Client";
			comment = "The Ultimate Client for the Best Minecraft Gameplay";
			categories = [ "Game" "ActionGame" "AdventureGame" "Simulation" ];
			keywords = [ "game" "minecraft" "mc" "hypixel" "pvp" "skyblock"];
		};

	in prev.appimageTools.wrapType2 {
		inherit name src;

		extraInstallCommands = let
			contents = prev.appimageTools.extract { inherit name src; };
		in ''
			mkdir -p "$out/share/applications"
			ln -s "${desktopItem}"/share/applications/* "$out/share/applications/"
			for i in 16 32 48 64 96 128 256 512 1024; do
				install -D ${contents}/${fname}.png $out/share/icons/hicolor/''${i}x$i/apps/${fname}.png
			done
		'';
	};
}
