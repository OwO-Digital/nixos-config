{ lib, pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    configFile.text = ''
      $env.config = {
        show_banner: false,
        edit_mode: vi
      }
    '';
  };

  programs.carapace = {
    # all in one autocompletion
    # supports: https://carapace-sh.github.io/carapace-bin/completers.html
    enable = true;
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "[](fg:red)"
        "[$hostname ](fg:white bg:red)"
        "[$username](fg:red bg:white)"
        "[ ](fg:white)"
        "[](fg:red)"
        "[$directory](fg:white bg:red)"
        "[ ](fg:red)"
        "[](fg:red)"
        "[\${custom.mountpoint}](fg:white bg:red)"
        "[ ](fg:red)"
        "\n"
        "$shell"
      ];

      custom.mountpoint = {
        description = "Mountpoint of the current directory";
        command = "findmnt -no SOURCE,TARGET -T .";
        when = "true";
        shell = [ "${lib.getExe pkgs.zsh}" ];
        format = "$output";
      };

      directory.format = "$path";

      hostname = {
        ssh_only = false;
        format = "$hostname";
      };

      username = {
        show_always = true;
        format = "$user";
      };

      shell = {
        disabled = false;

        zsh_indicator = "[  ](fg:white bg:red)[](red)";
        nu_indicator = "[  ](fg:white bg:red)[](red)";
        elvish_indicator = "[  ](fg:white bg:red)[](red)";
        bash_indicator = "[ bash ](fg:white bg:black)[](black)";
        fish_indicator = "[ fish ](fg:white bg:black)[](black)";
        powershell_indicator = "[ pwsh ](fg:white bg:black)[](black)";
        ion_indicator = "[ ion ](fg:white bg:black)[](black)";
        tcsh_indicator = "[ tcsh ](fg:white bg:black)[](black)";
        xonsh_indicator = "[ xonsh ](fg:white bg:black)[](black)";
        cmd_indicator = "[ cmd ](fg:white bg:black)[](black)";
        unknown_indicator = "[ ?? ](fg:white bg:black)[](black)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
