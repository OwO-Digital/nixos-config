{ config, pkgs, ... }:
let
  variables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
in
{
  home = {
    packages = with pkgs; [
      bitwarden
    ];

    sessionVariables = variables;
  };
  systemd.user.sessionVariables = variables;
  programs = {
    bash.sessionVariables = variables;
    nushell.environmentVariables = variables;
    zsh.sessionVariables = variables;
  };
}
