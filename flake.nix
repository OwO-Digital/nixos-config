{
  description = "owo.digital flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Do not rename the following input
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

      system.hosts = {
        ocean-t460.modules = with inputs; [
          nixos-hardware.nixosModules.lenovo-thinkpad-t460
        ];
      };
    };
}
