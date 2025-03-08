{inputs, pkgs, ...}:

# FIXME: Currently only works in a FHS env (e.g. steam-run)

pkgs.buildDotnetModule rec {
  pname = "WheelWizard";
  version = "2.0.1";

  src = inputs.pkg-wheelwizard;
  nugetDeps = ./deps.nix;

  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

  executables = [
    pname
  ];

  nativeBuildInputs = with pkgs; [ copyDesktopItems ];

  desktopItems = [ (pkgs.makeDesktopItem {
    name = "com.github.TeamWheelWizard.WheelWizard";
    exec = pname;

    icon = pname;
    desktopName = "WheelWizard";
    genericName = "Launcher for Retro Rewind, a Mario Kart Wii mod";
    terminal = false;
    categories = [ "Game" ];
    keywords = [ ];
    #extraConfig."SingleMainWindow" = "true";
  }) ];

  projectFile = "${pname}/${pname}.csproj";
}