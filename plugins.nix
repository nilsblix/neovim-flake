{ pkgs }: with pkgs.vimPlugins; [
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
]
