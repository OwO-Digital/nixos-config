{
  description = "the gayest flake that you have ever seen";

  inputs = {

    # General
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "unstable";
      inputs.home-manager.follows = "home";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "stable";
    };
    gauntlet = {
      url = "github:project-gauntlet/gauntlet";
      inputs.nixpkgs.follows = "unstable";
    };
    wezterm = {
      url = "github:wezterm/wezterm?dir=nix";
      inputs.nixpkgs.follows = "unstable";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };
    nixHW.url = "github:nixos/nixos-hardware/master";
    f2k = {
      url = "github:moni-dz/nixpkgs-f2k";
      inputs.nixpkgs.follows = "unstable-small";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "unstable";
    };
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "unstable";
    };
    vscode-ext.url = "github:nix-community/nix-vscode-extensions";
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "stable";
    };

    ## Hyprland stuff
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    eden-emu = {
      url = "github:grantimatter/eden-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    # QT/KDE theming
    darkly = {
      url = "github:Bali10050/Darkly";
      inputs.nixpkgs.follows = "unstable";
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "unstable";
    };
    breeze-icons-chameleon = {
      # doesn't have releases, which would make it
      # hard to manage outside of a flake input
      type = "github";
      owner = "L4ki";
      repo = "Breeze-Chameleon-Icons";
      flake = false;
    };

    # Hoyoverse games
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    lsfg-vk-flake = {
      type = "github";
      owner = "pabloaul";
      repo = "lsfg-vk-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    mprisqueeze = {
      type = "github";
      owner = "jecaro";
      repo = "mprisqueeze";
      inputs.nixpkgs.follows = "stable";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # Nixpkgs
    unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs.follows = "unstable";
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , f2k
    , vscode-ext
    , niri
    , emacs-overlay
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

            "fluffychat-linux-1.22.1" # isn't really insecure
            "fluffychat-linux-1.23.0"
            "cinny-unwrapped-4.2.3"
            "cinny-4.2.3"
            "olm-3.2.16" # this is what marks fluffy and many other matrix things as insecure
            "qtwebengine-5.15.19" # apparently needed for fontconfig (according to what elly told me -emi)
          ];
        };

        overlays = importNixFiles ./overlays ++
          [
            nur.overlays.default
            f2k.overlays.default
            vscode-ext.overlays.default
            niri.overlays.niri
            emacs-overlay.overlay
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
