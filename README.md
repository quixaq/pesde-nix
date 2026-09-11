# pesde-nix

-----

> Archived: `pesde` is in nixpkgs unstable as of writing, so this flake is not needed anymore. Use the nixpkgs package.

-----

Nix Flake for [pesde](https://github.com/pesde-pkg/pesde)

## Usage
Run without installing:
```bash
nix run git+https://codeberg.org/quixaq/pesde-nix
```

## Installation
Add this to your `flake.nix` inputs:
```nix
inputs.pesde-nix.url = "git+https://codeberg.org/quixaq/pesde-nix";
```
And import it as a module. It will add pesde to your system packages:
```nix
outputs = { nixpkgs, pesde-nix, ... }: {
  nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      pesde-nix.nixosModules.default
    ];
  };
};
```
