{ pkgs, ... }: {

  # NOTE: waiting on PR so rmpc works with mopidy:
  # https://github.com/mopidy/mopidy-mpd/pull/57
  # (rmpc requires binary responses, mopidy doesn't provide them yet, rmpc doesn't check protocol version)

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
