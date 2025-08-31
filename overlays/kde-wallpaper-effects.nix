{ inputs, lib, ... }:

final: prev: {
  plasma-wallpaper-effects = prev.stdenv.mkDerivation rec {
    pname = "plasma-wallpaper-effects";
    version = "0.6.1";

    src = prev.fetchFromGitHub {
      owner = "luisbocanegra";
      repo = "plasma-wallpaper-effects";
      rev = "v${version}";
      hash = "sha256-1vj6Yn/R7OeJuQYdXj2tE8r/PvUMzBdPPCBOhdP6FDE=";
    };

    nativeBuildInputs = with prev; [
      cmake
      extra-cmake-modules
      kdePackages.wrapQtAppsHook
    ];

    buildInputs = with prev.kdePackages; [
      libplasma
      plasma5support
    ];

    meta = {
      description = "KDE Plasma Widget to enable Active Blur and other effects for all Wallpaper Plugins";
      homepage = "https://github.com/luisbocanegra/plasma-wallpaper-effects";
      platforms = lib.platforms.linux;
      license = with lib.licenses; [
        gpl3Only
      ];
    };
  };
}
