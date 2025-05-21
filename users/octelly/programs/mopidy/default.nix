{ pkgs, ... }: {

  # WARN: this module is broken due to an upstream issue:
  # https://github.com/mopidy/mopidy-mpd/issues/73

  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [

      # control
      mopidy-mpd
      mopidy-mpris

      # library
      mopidy-subidy

      # use mpd-scribble for scrobbling
    ];
  };

  programs.rmpc = {
    enable = true;
  };
}
