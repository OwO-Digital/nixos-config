{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib
, # You also have access to your flake's inputs.
  inputs
, # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs
, ...
}:

let

  owner = "ipodtouch0218";
  repo = "NSMB-MarioVsLuigi";
  version = "1.7.1.0-beta";
  pname = "MarioVsLuigi";
  platform = "Linux";

  desktop = pkgs.makeDesktopItem {
    name = "com.github.${owner}.${pname}";
    exec = pname;

    icon = pname;
    desktopName = "New Super Mario Bros. VS";
    genericName = "Standalone Unity remake of New Super Mario Bros DS' multiplayer gamemode, \"Mario vs Luigi\"";
    terminal = false;
    categories = [ "Game" "ArcadeGame" ];
    keywords = [ "nsmb" ];
    prefersNonDefaultGPU = true;
    extraConfig."SingleMainWindow" = "true";
  };

in
pkgs.stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = pkgs.fetchzip {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${pname}-${platform}-v${version}.zip";
    hash = "sha256-UrpUjE0MD0ayIU69wm+f1e72WStUQD14+CysdkDefrA=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = with pkgs; [ copyDesktopItems ];
  desktopItems = [ desktop ];

  installPhase =
    let
      binPath = "$out/opt/${owner}/${pname}";
    in
    "
      runHook preInstall

      mkdir -p $(dirname ${binPath})
      mkdir -p $out/bin

      ln -s $src ${binPath}

      echo \"${binPath}/linux.x86_64\" >> $out/bin/${pname}
      chmod +x $out/bin/${pname}

      runHook postInstall
    ";
}
