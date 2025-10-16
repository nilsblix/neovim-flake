# Neovim configuration deployed via Nix

Inspired by [this flake](https://github.com/gvolpe/neovim-flake/tree/main) as
it exposes Neovim nightly as a runnable package.

Simply run `$ nix run github:nilsblix/neovim-flake` to test it.

## Usage

- Run locally from this repo: `nix run .`
- Or run remotely: `nix run github:nilsblix/neovim-flake`

This flake packages Neovim Nightly and bundles a small, educational config with
a few plugins. No runtime plugin manager is required—plugins are provided by
Nix.

## Overlay

You can also use this as an overlay in your system or home configuration:

```
outputs = { nixpkgs, ... }@inputs: let
  overlays = [
    inputs.neovim-flake.overlays.default
  ];
  pkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
in {
  environment.systemPackages = [ pkgs.neovim-flake ];
}
```

The overlay exposes the configured Neovim as `pkgs.neovim-flake` and composes
the upstream neovim-nightly overlay automatically.
