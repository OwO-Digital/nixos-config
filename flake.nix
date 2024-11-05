{
  description = "owo.digital flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Official hardware config templates
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Do not rename the following input
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User-specific options
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HM Vim configuration module
    nixvim = {
      url = "github:nix-community/nixvim";
      # NOTE:
      # there are different branches for non-unstable nixpkgs
      # e.g. "github:nix-community/nixvim/nixos-23.05"

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Generate documentation for Nix Flakes.
    snowfall-frost = {
      url = "github:snowfallorg/frost";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # building Poetry Python packages
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### PACKAGE SOURCES ###
    pkg-fushigi = {
      type = "github";
      owner = "shibbo";
      repo = "Fushigi";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "owo-digital";

        meta = {
          name = "owo-digital";
          title = "owo.digital";
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        snowfall-frost.overlays.default
      ];

      system.hosts = {
        ocean-t460.modules = with inputs; [
          nixos-hardware.nixosModules.lenovo-thinkpad-t460
        ];
      };

      # global Home Manager modules
      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
      ];
    };
}
