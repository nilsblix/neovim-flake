{ inputs, pkgs }: let
    makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
        inherit pname src;
        version = src.lastModifiedDate;
    };
in with pkgs.vimPlugins; [
    nvim-highlight-colors
    mini-trailspace
    mini-align
    mini-hues

    vscode-nvim
    colibri-vim
    seoul256-vim
    ayu-vim
    (makeNeovimPlugin inputs.y9nika-nvim "y9nika")
    (makeNeovimPlugin inputs.atlas-nvim "atlas")

    oil-nvim
    fzf-lua
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
