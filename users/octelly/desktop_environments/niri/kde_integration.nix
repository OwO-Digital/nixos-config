{ pkgs, lib, ... }:
{
  # I just don't like Gnome Keyring
  # (Niri flake enables it by default)
  services.gnome-keyring.enable = lib.mkForce false;

  programs.niri.settings.environment = {
    "KDE_SESSION_VERSION" = "6";
    "XDG_CURRENT_DESKTOP" = "KDE";
    #"KDE_APPLICATIONS_AS_SCOPE" = "1";

    # WARN: this is the user ID
    # I have found, that my ID is 1001 with our shared setup
    # but this could change!!!!
    "KDE_SESSION_UID" = "1001";

    # NOTE: I have no clue why this is necessary
    # but it fixes Nheko for example
    "QML2_IMPORT_PATH" = "${pkgs.kdePackages.libplasma}";
  };

  home.packages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager

    # this likely needs to be a system package, but including it here shouldn't hurt
    kdePackages.kwallet-pam
  ];

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  programs.niri.settings.spawn-at-startup = [
    # https://wiki.archlinux.org/title/KDE_Wallet#Unlocking_KWallet_automatically_in_a_window_manager
    {
      command = [ "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init" ];
    }
  ];
}
