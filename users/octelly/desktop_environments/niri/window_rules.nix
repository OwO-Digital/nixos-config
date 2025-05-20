{ ... }:
{
  programs.niri.settings.window-rules = [
    {
      # open non-main Steam windows as floating
      matches = [{ app-id = "steam"; }];
      excludes = [{
        # Regex:
        # ^ is the start of the string
        # $ is the end of the string
        # (this makes it not apply to e.g. "Steam Settings")
        title = "^Steam$";
      }];
      open-floating = true;
    }
  ];
}
