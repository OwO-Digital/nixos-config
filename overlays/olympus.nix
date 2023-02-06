{ inputs, ... }:
let
	pkgOlympus = prev.stdenv.mkDerivation rec {
		pname = "olympus";
		version = "2681";

		# https://everestapi.github.io/
		src = prev.fetchzip {
			url = "https://dev.azure.com/EverestAPI/Olympus/_apis/build/builds/${version}/artifacts?artifactName=linux.main&$format=zip#linux.main.zip";
			hash = "sha256-r+Zqby5q4FfLaCCu56WW8i6y1GCUFyXeTCRoCEPbtEY=";
		};

		buildInputs = [ pkgs.unzip ];
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
in
final: prev: {
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
