{ inputs, pkgs }: let
    makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
        inherit pname src;
        version = src.lastModifiedDate;
    };
in with pkgs.vimPlugins; [
    vim-trailing-whitespace
    vim-fugitive
    tabular

    nvim-highlight-colors

    vscode-nvim
    github-nvim-theme
    (makeNeovimPlugin inputs.cursor-light-nvim "cursor-light")
    (makeNeovimPlugin inputs.carrot-nvim "carrot")
    (makeNeovimPlugin inputs.jb-nvim "jb")

    oil-nvim
    fzf-lua
    nvim-treesitter
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
