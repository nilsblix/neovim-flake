{
    description = "Educational Neovim Nightly configuration via Nix Flakes";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
        flake-utils.lib.eachDefaultSystem (system:
            let
                overlays = [ neovim-nightly-overlay.overlays.default ];
                pkgs = import nixpkgs {
                    inherit system overlays;
                };

                plugins = with pkgs.vimPlugins; [
                    vim-surround
                    vim-trailing-whitespace

                    # Ui
                    sonokai
                    telescope-nvim
                    plenary-nvim
                    oil-nvim

                    nvim-treesitter.withAllGrammars
                    nvim-lspconfig
                    blink-cmp
                    fidget-nvim
                ];

                myNeovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
                    withNodeJs = false;
                    withRuby = false;
                    withPython3 = true;
                    configure = {
                        packages.myVimPackage = {
                            start = plugins;
                            opt = [ ];
                        };
                        customRC = "lua << EOF\n" + builtins.readFile ./nvim/init.lua + "\nEOF";
                    };
                };
            in {
                # nix run .
                packages.default = myNeovim;

                # nix run
                apps.default = {
                    type = "app";
                    program = "${myNeovim}/bin/nvim";
                    meta = {
                        description = "Neovim Nightly with a small educational config";
                        mainProgram = "nvim";
                    };
                };
            });
}
