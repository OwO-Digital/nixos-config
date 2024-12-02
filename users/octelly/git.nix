{ ... }:
{
  programs.git = {
    enable = true;

    userName = "Octelly";
    userEmail = "octelly@owo.digital";
  };

  # log in to GitHub and other popular hosts
  # without setup
  programs.git-credential-oauth.enable = true;
}
