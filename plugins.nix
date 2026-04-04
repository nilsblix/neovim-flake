{ inputs, pkgs }: let
    # makeNeovimPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
    #     inherit pname src;
    #     version =
    #         if builtins.isAttrs src && src ? lastModifiedDate
    #         then src.lastModifiedDate
    #         else "0";
    # };
in with pkgs.vimPlugins; [
    nvim-highlight-colors
    mini-trailspace
    mini-align
    mini-hues

    vscode-nvim
    colibri-vim
    seoul256-vim

    oil-nvim
    fzf-lua
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    blink-cmp
]
