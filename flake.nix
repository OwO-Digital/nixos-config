{
  description = "the gayest flake that you have ever seen";

  inputs = {

    # General
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixHW.url = "github:nixos/nixos-hardware/master";
    f2k = {
      url = "github:moni-dz/nixpkgs-f2k";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    vscode-ext.url = "github:nix-community/nix-vscode-extensions";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland stuff
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.36.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr-smw = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.36.0";
      inputs.hyprland.follows = "hyprland";
    };

    # Flake for testing COSMIC on NixOS
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixpkgs
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    master.url = "github:nixos/nixpkgs/master";

    nixpkgs.follows = "unstable";

    ### newm is currently unmaintained...
    # newm = {
    # 	url = "github:jbuchermn/newm";
    # 	inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , f2k
    , vscode-ext
    , ...
    } @ inputs:
    let
      inherit (lib.ext) importNixFiles mapHosts;

      repoConf = {
        config = {
          allowUnfree = true;
          allowBroken = true;
          permittedInsecurePackages = [
            "electron-11.5.0"
          ];
        };

        overlays = importNixFiles ./overlays ++
          [
            nur.overlay
            f2k.overlays.default
            vscode-ext.overlays.default
          ];
      };

      lib = nixpkgs.lib.extend (final: prev: {
        ext = import ./lib
          { inherit inputs repoConf; lib = prev; };
      });

    in
    {
      # nixosModules = mapModulesRec ./modules;
      nixosConfigurations = mapHosts ./hosts;
    };
}
