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

  #inherit (inputs.pkg-fushigi) owner repo;
  owner = "shibbo";
  repo = "Fushigi";
  pname = repo;

  desktop = pkgs.makeDesktopItem {
    name = "com.github.${owner}.${repo}";
    exec = pname;

    icon = pname;
    desktopName = repo;
    genericName = "Editor for Super Mario Bros. Wonder";
    terminal = false;
    categories = [ "Game" ];
    keywords = [ ];
    prefersNonDefaultGPU = true;
    extraConfig."SingleMainWindow" = "true";
  };

in
pkgs.buildDotnetModule {
  inherit pname;
  version = "0.1";

  src = inputs.pkg-fushigi;
  nugetDeps = ./deps.nix;

  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

  executables = [
    pname
  ];

  nativeBuildInputs = with pkgs; [ copyDesktopItems ];
  desktopItems = [ desktop ];

  projectFile = "${repo}/${repo}.csproj";
}
