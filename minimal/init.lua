local opt = vim.o
local keymap = vim.keymap

opt.number = true
opt.incsearch = true
opt.hlsearch = true

opt.title = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.scrolloff = 10
opt.wrap = false

opt.autoread = true
opt.swapfile = false
vim.g.mapleader = " "

opt.mouse = "a"
opt.clipboard = opt.clipboard .. "unnamed"
opt.guicursor = "n-v-i-c:block-Cursor"

vim.highlight.priorities.semantic_tokens = 120

keymap.set("n", "<leader>p", "<C-^>")
keymap.set("n", "<leader>ya", "mzggyG`z")
keymap.set("n", "<C-c>", ":cnext<CR>")
keymap.set("n", "<C-k>", ":cprev<CR>")
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
keymap.set("n", "<leader>i", ":Inspect<CR>")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ocaml", "ocamlinterface", "ocamllex", "ocamlyacc" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.nils",
    callback = function()
        vim.bo.filetype = "python"
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})
vim.cmd.colorscheme("carrot")

-- =============================================================================
--                                    Oil
-- =============================================================================
require("oil").setup({
    default_file_explorer = true,
    delete_to_trash = true,
    columns = {},
    view_options = { show_hidden = true },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

keymap.set("n", "<leader>n", ":Oil<CR>", { silent = true })

-- =============================================================================
--                                 Treesitter
-- =============================================================================
require("nvim-treesitter.configs").setup({
    ensure_installed = {},
    sync_install = false,
    auto_install = false,
    indent = { enable = true, },
    highlight = { enable = true, },
})
