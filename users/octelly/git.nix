{ pkgs, lib, ... }:
let
  use_gh = true;
in
{
  programs.git = {
    enable = true;

    userName = "Octelly";
    userEmail = "octelly@owo.digital";
    extraConfig.credential = {
      "https://github.com" = lib.mkIf use_gh {
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };

  #programs.gh = {
  #  enable = true;
  #};

  home.packages = lib.optional use_gh pkgs.gh;

  # log in to GitHub and other popular hosts
  # without setup
  #programs.git-credential-oauth.enable = true;
}
