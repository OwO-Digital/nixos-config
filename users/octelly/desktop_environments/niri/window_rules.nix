{ ... }:
{
  programs.niri.settings.window-rules = [
    {
      # open non-main Steam windows as floating
      matches = [{ app-id = "steam"; }];
      excludes = [{ title = "Steam"; }];
      open-floating = true;
    }
  ];
}
