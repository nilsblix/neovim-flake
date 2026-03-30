{
    description = "Neovim nightly configuration with Nix";

    nixConfig = {
        extra-substituters = [
            "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

        y9nika-nvim.url = "github:y9san9/y9nika.nvim";
        y9nika-nvim.flake = false;

        atlas-nvim.url = "github:huyvohcmc/atlas.vim";
        atlas-nvim.flake = false;
    };

    outputs = inputs@{ nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
        let
            makeConfiguredNeovim = { pkgs, baseNeovim, pluginsPath, configPath }:
                let
                    plugins = import pluginsPath { inherit inputs; pkgs = pkgs; };
                in
                    pkgs.wrapNeovimUnstable baseNeovim {
                        withNodeJs = false;
                        withRuby = false;
                        withPython3 = true;
                        plugins = plugins;
                        luaRcContent = builtins.readFile configPath;
                    };

            overlay = final: _:
                let
                    system = final.stdenv.hostPlatform.system;
                in
                    {
                        neovim-flake-maximal = makeConfiguredNeovim {
                            pkgs = final;
                            baseNeovim = neovim-nightly-overlay.packages.${system}.default;
                            pluginsPath = ./plugins.nix;
                            configPath = ./init.lua;
                        };
                        neovim-flake = final.neovim-flake-maximal;
                    };
        in
            {
                overlays.default = overlay;
            }
        //
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs { inherit system; };
                nightlyNeovim = neovim-nightly-overlay.packages.${system}.default;
                maximalNeovim = makeConfiguredNeovim {
                    inherit pkgs;
                    baseNeovim = nightlyNeovim;
                    pluginsPath = ./plugins.nix;
                    configPath = ./init.lua;
                };
            in {
                devShells.default = pkgs.mkShell {
                    packages = with pkgs; [
                        lua-language-server
                    ];
                };

                packages.default = maximalNeovim;
                packages.maximal = maximalNeovim;

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
