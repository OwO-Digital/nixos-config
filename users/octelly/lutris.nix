{ pkgs, lib, ... }: {
  # fix for
  # https://github.com/NixOS/nixpkgs/issues/372422
  xdg.dataFile."lutris/runtime/umu/umu-run".source =
    "${pkgs.umu-launcher}/bin/umu-run";
  xdg.dataFile."lutris/runtime/umu/umu_run.py".source =
    "${pkgs.umu-launcher}/bin/umu-run";

  home.packages = with pkgs; [
    lutris
  ];
}
