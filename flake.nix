{
    description = "Neovim nightly configuration with Nix";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

        helix-nvim = {
            url = "github:nilsblix/helix.nvim";
            flake = false;
        };
    };

    outputs = inputs@{ self, nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
        let
            # Compose upstream nightly overlay with our own overlay that exposes
            # the configured Neovim as `pkgs.neovim-flake`.
            overlay = nixpkgs.lib.composeManyExtensions [
                neovim-nightly-overlay.overlays.default
                (final: prev:
                    let
                        plugins = import ./plugins.nix { inherit inputs; pkgs = final; };
                    in {
                        # Expose the wrapped nightly neovim with this config
                        neovim-flake = final.wrapNeovim final.neovim-unwrapped {
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
                myNeovim = pkgs.neovim-flake;
            in {
                devShells.default = pkgs.mkShell {
                    packages = with pkgs; [
                        lua-language-server
                    ];
                };

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
