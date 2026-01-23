{ inputs, pkgs }: let
    makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
        inherit pname src;
        version = src.lastModifiedDate;
    };
in with pkgs.vimPlugins; [
    vim-surround
    vim-trailing-whitespace
    vim-fugitive

    # Ui
    sonokai
    rose-pine
    tokyonight-nvim
    catppuccin-nvim
    vscode-nvim
    vague-nvim
    (makeNeovimPlugin inputs.helix-nvim "helix")
    (makeNeovimPlugin inputs.cursor-light-nvim "cursor-light")
    (makeNeovimPlugin inputs.cursor-dark-nvim "cursor-dark")
    (makeNeovimPlugin inputs.carrot-nvim "carrot")

    oil-nvim
    fzf-lua
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
