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
