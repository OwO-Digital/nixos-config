{ pkgs, lib, ... }:
{
  # I just don't like Gnome Keyring
  # (Niri flake enables it by default)
  services.gnome-keyring.enable = lib.mkForce false;

  home.packages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager

    # this likely needs to be a system package, but including it here shouldn't hurt
    kdePackages.kwallet-pam
  ];

  programs.niri.settings.spawn-at-startup = [
    # https://wiki.archlinux.org/title/KDE_Wallet#Unlocking_KWallet_automatically_in_a_window_manager
    { command = [ "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init" ]; }
  ];
}
