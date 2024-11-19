{
  description = "the gayest flake that you have ever seen";

  inputs = {

    # General
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
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

    ## Hyprland stuff
    #hyprland = {
    #  url = "github:hyprwm/Hyprland?ref=v0.36.0";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #hypr-smw = {
    #  url = "github:Duckonaut/split-monitor-workspaces/d0012b8b0f764e32dd7b82f7a94b8c30197d7dc8";
    #  inputs.hyprland.follows = "hyprland";
    #};
    #hypr-hy3 = {
    #  url = "github:outfoxxed/hy3?ref=hl0.36.0";
    #  inputs.hyprland.follows = "hyprland";
    #};

    # Flake for testing COSMIC on NixOS
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hoyoverse games
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixpkgs
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-24.05";
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
            "freeimage-unstable-2021-11-01" # for EmulationStation DE (desktop edition)
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
