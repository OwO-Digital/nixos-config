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

    # Generate documentation for Nix Flakes.
    snowfall-frost = {
      url = "github:snowfallorg/frost";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### PACKAGE SOURCES ###
    # they would go here :3
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
    };
}
