# pesde-nix

Nix Flake for [pesde](https://github.com/pesde-pkg/pesde)

## Usage
Run without installing:
```bash
nix run github:quixaq/pesde-nix
```

## Installation
Add this to your `flake.nix` inputs:
```nix
inputs.pesde-nix.url = "github:quixaq/pesde-nix";
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
