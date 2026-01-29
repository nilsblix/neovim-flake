{ inputs, pkgs }: let
    makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
        inherit pname src;
        version = src.lastModifiedDate;
    };
in with pkgs.vimPlugins; [
    (makeNeovimPlugin inputs.carrot-nvim "carrot")
    oil-nvim
    nvim-treesitter
    nvim-treesitter-parsers.zig
    nvim-treesitter-parsers.rust
    nvim-treesitter-parsers.html
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.sql
    nvim-treesitter-parsers.nix
    nvim-treesitter-parsers.ocaml
    nvim-treesitter-parsers.go
    nvim-treesitter-parsers.cpp
    nvim-treesitter-parsers.c
]
