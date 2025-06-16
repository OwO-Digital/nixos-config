{ inputs, ... }:

final: prev:
{
  unstable-znver3 = import inputs.unstable {
    config = { allowUnfree = true; };
    localSystem = {
      gcc.arch = "znver3";
      gcc.tune = "znver3";
      system = "x86_64-linux";
    };
  };
}
