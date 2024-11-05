{ inputs
, pkgs
}:

let
  inherit (inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication defaultPoetryOverrides;
in
mkPoetryApplication {
  projectDir = ./.;
  overrides = defaultPoetryOverrides.extend (self: super:
    {
      # see https://github.com/nix-community/poetry2nix/blob/7619e43c2b48c29e24b88a415256f09df96ec276/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
      paho-mqtt = super.paho-mqtt.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ super.hatchling ];
      });
      pyright = super.pyright.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
      });
    }
  );
}
