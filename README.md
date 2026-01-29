# Neovim-nightly configuration deployed via Nix

Inspired by [this flake](https://github.com/gvolpe/neovim-flake/tree/main) as
it exposes Neovim nightly as a runnable package.

Simply run `$ nix run github:nilsblix/neovim-flake` to test it.

## Flake outputs

This flake exposes two endopoints:
- **maximal**: Maximally configured Neovim package.
- **minimal**: Minimally configured Neovim package.

Both of these are configured according to my needs, therfore explanations on
keymaps/workflows are non-existent.

## Usage

- Run locally from this repo: `nix run .`
- Or run remotely: `nix run github:nilsblix/neovim-flake`

These commands will by default run the **maximally** configured Neovim package.

## Overlay

You can also use these packages as an overlay in your system or home
configuration:

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

The overlay exposes the configured Neovim as `pkgs.neovim-flake`, which
defaults to the **maximal** configuration and composes the upstream
neovim-nightly overlay automatically.
