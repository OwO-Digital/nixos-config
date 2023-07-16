{ inputs, .. }:

final: prev: {
	srb2kart = (prev.srb2kart.overrideAttrs (old:
		let
			release_tag = "v1.6";

			assets = prev.fetchurl {
				url = "https://github.com/STJr/Kart-Public/releases/download/${release_tag}/AssetsLinuxOnly.zip";
				sha256 = "sha256-ejhPuZ1C8M9B0S4+2HN1T5pbormT1eVL3nlivqOszdE=";
			};
			
			swDesktop = prev.makeDesktopItem {
				name = old.pname;
				exec = "srb2kart -software";
				terminal = false;
				icon = old.pname;
				desktopName = "Sonic Robo Blast 2 Kart (software)";
				genericName = old.meta.description;
				categories = [ "Game" "ArcadeGame" ];
			};
			
			oglDesktop = makeDesktopItem {
				name = old.pname + "-opengl";
				exec = "srb2kart -opengl";
				terminal = false;
				icon = old.pname;
				desktopName = "Sonic Robo Blast 2 Kart (OpenGL)";
				genericName = old.meta.description;
				categories = [ "Game" "ArcadeGame" ];
			};
		in {
			version = "1.6.0";

			src = prev.fetchFromGitHub {
  				owner = "STJr";
  				repo = "Kart-Public";
  				rev = release_tag;
				# WARN: old hash will use old src from cache even after changing release tag
				#       remove the hash value and update it after updating release tag!!!
				sha256 = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
  			};

			preConfigure = ''
				mkdir assets/installer
				pushd assets/installer
				unzip ${assets} "*.kart" mdls.dat srb2.srb "mdls/"
				popd
			'';

			#postInstall = _.postInstall + ''
			#	mkdir -p $out/share/icons/hicolor/64x64/apps
			#	cp src/sdl/srb2icon.png $out/share/icons/hicolor/64x64/apps/${_.pname}.png
			#'';

			buildInputs = [ prev.xorg.libXpm ] ++ old.buildInputs;
			nativeBuildInputs = [ prev.copyDesktopItems ] ++ old.nativeBuildInputs;
			
			desktopItems = [ swDesktop oglDesktop ];
		}                                            	
	)) 
