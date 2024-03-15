{ config
, ...
}: {
  programs.eza = {
    enable = true;

    ## Failed assertions:
    ##    - apro profile: The option definition `programs.eza.enableAliases' in `/nix/store/8my009vjlllpwxj7cqg1bygwrvpfmkp7-source/users/apro/programs/utils/eza.nix' no longer has any effect; please remove it.
    ##    'programs.eza.enableAliases' has been deprecated and replaced with integration
    ##    options per shell, for example, 'programs.eza.enableBashIntegration'.
    ## 
    ##    Note, the default for these options is 'true' so if you want to enable the
    ##    aliases you can simply remove 'rograms.eza.enableAliases' from your
    ##    configuration.
    ##
    ## Commented out by Elly:
    # enableAliases = false;
  };
}
