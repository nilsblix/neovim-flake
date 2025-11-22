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
    (makeNeovimPlugin inputs.helix-nvim "helix")
    (makeNeovimPlugin inputs.lemons-nvim "lemons")
    # telescope-nvim
    # plenary-nvim
    oil-nvim

    fzf-lua

    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
    fidget-nvim
]
