{
    description = "Neovim nightly configuration with Nix";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

        helix-nvim.url = "github:nilsblix/helix.nvim";
        helix-nvim.flake = false;

        cursor-light-nvim.url = "github:vpoltora/cursor-light.nvim";
        cursor-light-nvim.flake = false;

        cursor-dark-nvim.url = "github:nilsblix/cursor-dark.nvim";
        cursor-dark-nvim.flake = false;

        carrot-nvim.url = "github:nilsblix/carrot.nvim";
        carrot-nvim.flake = false;
    };

    outputs = inputs@{ self, nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
        let
            makeConfiguredNeovim = { pkgs, pluginsPath, configPath }:
                let
                    plugins = import pluginsPath { inherit inputs; pkgs = pkgs; };
                in
                    pkgs.wrapNeovim pkgs.neovim-unwrapped {
                        withNodeJs = false;
                        withRuby = false;
                        withPython3 = true;
                        configure = {
                            packages.myVimPackage = {
                                start = plugins;
                                opt = [ ];
                            };
                            customRC = "lua << EOF\n" + builtins.readFile configPath + "\nEOF";
                        };
                    };

            # Compose upstream nightly overlay with our own overlay that exposes
            # the configured Neovim packages.
            overlay = nixpkgs.lib.composeManyExtensions [
                neovim-nightly-overlay.overlays.default
                (final: prev: {
                    neovim-flake-minimal = makeConfiguredNeovim {
                        pkgs = final;
                        pluginsPath = ./minimal/plugins.nix;
                        configPath = ./minimal/init.lua;
                    };
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
                minimalNeovim = pkgs.neovim-flake-minimal;
                maximalNeovim = pkgs.neovim-flake-maximal;
            in {
                devShells.default = pkgs.mkShell {
                    packages = with pkgs; [
                        lua-language-server
                    ];
                };

                packages = {
                    minimal = minimalNeovim;
                    maximal = maximalNeovim;
                    default = minimalNeovim;
                };

                apps = {
                    minimal = {
                        type = "app";
                        program = "${minimalNeovim}/bin/nvim";
                        meta = {
                            description = "Neovim Nightly with a minimal config";
                            mainProgram = "nvim";
                        };
                    };
                    maximal = {
                        type = "app";
                        program = "${maximalNeovim}/bin/nvim";
                        meta = {
                            description = "Neovim Nightly with a maximal config";
                            mainProgram = "nvim";
                        };
                    };
                    default = {
                        type = "app";
                        program = "${minimalNeovim}/bin/nvim";
                        meta = {
                            description = "Neovim Nightly with a minimal config";
                            mainProgram = "nvim";
                        };
                    };
                };
            });
}
