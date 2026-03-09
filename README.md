# Neovim-nightly configuration deployed via Nix

This flake wraps the nightly Neovim package from
[nix-community/neovim-nightly-overlay](https://github.com/nix-community/neovim-nightly-overlay).
That upstream flake publishes prebuilt nightly binaries through the
`nix-community` Cachix cache, so first startup does not need to compile Neovim
from source when that cache is enabled.

## Usage

- Run locally from this repo: `nix run .`
- Run remotely: `nix run github:nilsblix/neovim-flake`

For remote `nix run`, Nix should pick up this flake's `nixConfig` and offer to
trust the `nix-community` binary cache. Accepting that prompt avoids rebuilding
Neovim nightly from source.

## System packages

For NixOS, nix-darwin, or Home Manager, prefer using the package output
directly instead of the overlay path:

```nix
{
    nix.settings = {
        substituters = [
            "https://cache.nixos.org"
                "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };

    environment.systemPackages = [
        inputs.neovim-flake.packages.${pkgs.system}.default
    ];
}
```

This uses the exact nightly package output backed by the upstream binary cache,
then layers the local configuration on top.

## Overlay

An overlay is still available if you want `pkgs.neovim-flake`:

```nix
outputs = { nixpkgs, ... }@inputs: let
  overlays = [
    inputs.neovim-flake.overlays.default
  ];
  pkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
in {
  environment.systemPackages = [ pkgs.neovim-flake ];
}
```

If you use the overlay route from another flake, configure the `nix-community`
substituter in your top-level Nix settings as shown above.
