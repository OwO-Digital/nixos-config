{ inputs, lib, ... }:

final: prev: {
  go-hass-agent = prev.buildGoModule rec {
    pname = "go-hass-agent";
    version = "13.3.1";

    src = prev.fetchFromGitHub {
      owner = "joshuar";
      repo = "go-hass-agent";
      rev = "v${version}";

      # the build process checks multiple git subcommands
      # to gather information about the source being built
      #
      # plan was to use the same fakeGit approach as in
      # https://github.com/jtojnar/nixfiles/blob/32c6e134209a9df89654a2cd769875a1beeafe66/pkgs/vikunja/vikunja-api/default.nix
      # but it at the very least seems like more effort
      # than I'm willing to put into this 
      leaveDotGit = true;

      hash = "sha256-ad1VAsfoAivZ3Lr2gp8qFgJQ6FUFx9pH/a9ib7aVwRk=";
    };

    desktopItems = [
      (prev.makeDesktopItem {
        # https://github.com/joshuar/go-hass-agent/blob/main/assets/go-hass-agent.desktop
        name = pname;
        desktopName = pname;
        comment = meta.description;
        icon = pname;
        exec = "${pname} run";
        terminal = false;
        categories = [ "System" "Monitor" ];
        startupNotify = true;
        keywords = [ "home" "assistant" "hass" ];
      })
    ];

    nativeBuildInputs = with prev; [
      copyDesktopItems
      git
      mage
      pkg-config
    ];

    buildInputs = with prev; [
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXi.dev # XInput
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXxf86vm
    ];

    vendorHash = "sha256-xgOv+7Z9vYFF7YQn1upbE9n99HyJZHeXQcmgKOUyeAc=";

    buildPhase = ''
      runHook preBuild

      # Fixes “Error: error compiling magefiles” during build.
      export HOME=$(mktemp -d)

      mage -d build/magefiles -w . build:full

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp dist/go-hass-agent-amd64 $out/bin/go-hass-agent

      mkdir -p $out/share/pixmaps
      cp internal/ui/assets/go-hass-agent.png $out/share/pixmaps/${pname}.png

      runHook postInstall
    '';

    passthru = {
      gitDescribeCommand = "describe --tags --always --dirty";
    };

    meta = {
      description = "A Home Assistant, native app for desktop/laptop devices.";
      homepage = "https://github.com/joshuar/go-hass-agent";
      license = lib.licenses.mit;
	  mainProgram = "go-hass-agent";
    };
  };
}
