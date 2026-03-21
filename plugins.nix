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
    colibri-vim
    dracula-vim
    (makeNeovimPlugin inputs.cursor-light-nvim "cursor-light")
    (makeNeovimPlugin inputs.y9nika-nvim "y9nika")
    (makeNeovimPlugin inputs.jellybeans-nvim "jellybeans")

    oil-nvim
    fzf-lua
    nvim-treesitter
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
