{ inputs, ... }:

final: prev: {
  inputRedirectionClient-qt = prev.libsForQt5.callPackage
    ({ stdenv, lib, qtbase, qtgamepad, wrapQtAppsHook }: prev.stdenv.mkDerivation rec {
      pname = "InputRedirectionClient-qt";
      version = "2.1";

      src = prev.fetchFromGitHub {
        owner = "TuxSH";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-sXqPme/1kM3xvdGoc3UKww32vk3E4cIE0+tCk//vc/E=";
      };

      configurePhase = ''
        qmake
      '';

      buildInputs = [ qtbase qtgamepad ];
      nativeBuildInputs = [ wrapQtAppsHook ];

      installPhase = ''
        ls
        mkdir -p $out/bin
        cp InputRedirectionClient-Qt $out/bin
      '';
    })
    { };
}
