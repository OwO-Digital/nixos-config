# owo.digital flake

The flake with all the owo.digital dotfiles and packages and who knows what else.

## Making changes / developing

### Code structure

This repo uses [Snowfall lib](https://snowfall.org/guides/lib/quickstart/) and thus follows the folder structure described in Snowfall lib's documentation.

You should check the root `flake.nix` file for details specific to this repo's Snowfall lib configuration.

### Code formatting

In order to help keep a consistent code style for better readability, you should setup the following tools:

- Pre-commit ([Quickstart guide](https://pre-commit.com/#quick-start))
- EditorConfig ([Get an extension for your editor here](https://editorconfig.org/#download))

Pre-commit automatically runs nixpkgs-fmt on your commits, which is this repo's code style. Since nixpkgs-fmt enforces 2 space indentation (see the `.editorconfig` file in the root of this repo), EditorConfig is set to automatically set your editor to this indentation style.

**Please actually follow this 🥺**

### Recommended settings

#### VSCode

This repo includes configuration for the [Nix IDE extension](https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide). Formatting is set to use `nixpkgs-fmt` which you need to install through your package manager. This setup gets you suggestions, mouse hover information and all the other LSP goodness. 

### Manual actions

#### Fushigi

Fushigi may need a manual Nuget dependency lockfile (`packages/games/fushigi/deps.nix`) refresh when its input is updated:

```sh
nix build .#Fushigi.fetch-deps
./result packages/games/Fushigi/deps.nix
```

