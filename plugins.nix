{ inputs, pkgs }: let
    makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
        inherit pname src;
        version = src.lastModifiedDate;
    };
in with pkgs.vimPlugins; [
    vim-surround
    vim-trailing-whitespace

    # Ui
    sonokai
    (makeNeovimPlugin inputs.helix-nvim "helix")
    telescope-nvim
    plenary-nvim
    oil-nvim

    typst-preview-nvim
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
