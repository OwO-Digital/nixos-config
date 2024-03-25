{ pkgs
, lib
, config
, ...
}:

let

  pname = "picotron";
  author = "lexaloffle";

  desktop = pkgs.makeDesktopItem {
    name = "com.${author}.${pname}";
    exec = pname;

    icon = pname;
    desktopName = "Picotron";
    genericName = "A Fantasy Workstation";
    terminal = false;
    categories = [ "Game" "Education" "Graphics" "Development" ];
    keywords = [ "pico8" "picotron" ];
    prefersNonDefaultGPU = true;
    extraConfig."SingleMainWindow" = "true";
  };

in
pkgs.stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "0.1.0b2";

  src = pkgs.requireFile rec {
    name = "${pname}_${version}_amd64.zip";
    sha256 = "e71d5be8979d6af9f0d5994133046ce3c3c21fc837836508e2db0351fd7dcc05";

    message = ''
      Picotron isn't publicly available software and you have to supply your own copy.
      You can purchase your own copy at "https://www.lexaloffle.com/picotron.php".
      Please download the required file and add it to the Nix store with
        nix-store --add-fixed sha256 ${name}
    '';
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = with pkgs; [ unzip copyDesktopItems ];
  desktopItems = [ desktop ];

  installPhase = ''
    runHook preInstall

    unzip -j $src

    mkdir -p $out/bin
    mkdir -p $out/usr/share/icons/hicolor/128x128/apps/

    mv picotron $out/bin
    mv picotron_dyn $out/bin
    mv ${author}-${pname}.png $out/usr/share/icons/hicolor/128x128/apps/

    runHook postInstall
  '';
}
