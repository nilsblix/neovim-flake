{
    description = "Neovim nightly configuration with Nix";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

        cursor-light-nvim.url = "github:vpoltora/cursor-light.nvim";
        cursor-light-nvim.flake = false;

        carrot-nvim.url = "github:nilsblix/carrot.nvim";
        carrot-nvim.flake = false;

        jb-nvim.url = "github:nickkadutskyi/jb.nvim";
        jb-nvim.flake = false;
    };

    outputs = inputs@{ self, nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
        let
            makeConfiguredNeovim = { pkgs, pluginsPath, configPath }:
                let
                    plugins = import pluginsPath { inherit inputs; pkgs = pkgs; };
                in
                    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
                        withNodeJs = false;
                        withRuby = false;
                        withPython3 = true;
                        plugins = plugins;
                        luaRcContent = builtins.readFile configPath;
                    };

            # Compose upstream nightly overlay with our own overlay that exposes
            # the configured Neovim packages.
            overlay = nixpkgs.lib.composeManyExtensions [
                neovim-nightly-overlay.overlays.default
                (final: prev: {
                    neovim-flake-maximal = makeConfiguredNeovim {
                        pkgs = final;
                        pluginsPath = ./maximal/plugins.nix;
                        configPath = ./maximal/init.lua;
                    };
                    neovim-flake = final.neovim-flake-maximal;
                })
            ];
        in
            {
                overlays.default = overlay;
            }
        //
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs {
                    inherit system;
                    overlays = [ self.overlays.default ];
                };
                maximalNeovim = pkgs.neovim-flake-maximal;
            in {
                devShells.default = pkgs.mkShell {
                    packages = with pkgs; [
                        lua-language-server
                    ];
                };

                packages.default = maximalNeovim;

                apps = {
                    default = {
                        type = "app";
                        program = "${maximalNeovim}/bin/nvim";
                        meta = {
                            description = "Neovim Nightly config";
                            mainProgram = "nvim";
                        };
                    };
                };
            });
}
