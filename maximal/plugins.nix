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
    (makeNeovimPlugin inputs.helix-nvim "helix")
    (makeNeovimPlugin inputs.cursor-light-nvim "cursor-light")
    (makeNeovimPlugin inputs.cursor-dark-nvim "cursor-dark")
    (makeNeovimPlugin inputs.carrot-nvim "carrot")
    (makeNeovimPlugin inputs.fleet-nvim "fleet")

    oil-nvim
    fzf-lua
    nvim-treesitter
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
