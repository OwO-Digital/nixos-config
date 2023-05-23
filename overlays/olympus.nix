{ inputs, ... }:
final: prev:
	let
		pkgOlympus = prev.stdenv.mkDerivation rec {
			pname = "olympus";
			version = "3170";

			# https://everestapi.github.io/
			src = prev.fetchzip {
				url = "https://dev.azure.com/EverestAPI/Olympus/_apis/build/builds/${version}/artifacts?artifactName=linux.main&$format=zip#linux.main.zip";
				hash = "sha256-0w7vg4bwL6XZl6VkgP1T/iriBNWE1lnZtWnefNEL5Co=";
			};

			buildInputs = [ prev.unzip ];
			installPhase = ''
				mkdir -p "$out/opt/olympus/"
				mv dist.zip "$out/opt/olympus/" && cd "$out/opt/olympus/"
				unzip dist.zip && rm dist.zip
				mkdir $out && echo XDG_DATA_HOME=$out
				echo y | XDG_DATA_HOME="$out/share/" bash install.sh
				sed -i "/ldconfig/d" ./love && rm ./usr/lib/libSDL2-2.0.so.0
				sed -i "s/Exec=.*/Exec=olympus %u/g" ../../share/applications/Olympus.desktop
			'';
		};
	in {
	olympus = prev.buildFHSUserEnv {
		name = "olympus";
		runScript = "${pkgOlympus}/opt/olympus/olympus";
		targetPkgs = pkgs: with pkgs; [
			freetype
			zlib
			SDL2
			curl
			libpulseaudio
			gtk3
			glib
		];

		# https://github.com/EverestAPI/Olympus/blob/main/lib-linux/olympus.desktop
		# https://stackoverflow.com/questions/8822097/how-to-replace-a-whole-line-with-sed
		extraInstallCommands = ''cp -r "${pkgOlympus}/share/" $out'';
	};
}
