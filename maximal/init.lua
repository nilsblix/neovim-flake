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

require("carrot").setup({
    ui = true,
})

vim.cmd.colorscheme("carrot")

-- I'm not sure I love this. Maybe I will try this in the future. It seems cool,
-- and I do like the look of vim.o.cmdheight = 0.
--
-- opt.cmdheight = 0
-- require('vim._extui').enable({
--     enable = true, -- Whether to enable or disable the UI.
--     msg = {        -- Options related to the message module.
--         ---@type 'cmd'|'msg' Where to place regular messages, either in the
--         ---cmdline or in a separate ephemeral message window.
--         target = 'msg',
--         timeout = 2000, -- Time a message is visible in the message window.
--     },
-- })

-- =============================================================================
--                           nvim-highlight-colors
-- =============================================================================
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function()
        require("nvim-highlight-colors").setup({
            render = "background",
            enable_hex = true,
            enable_short_hex = true,
            enable_rgb = true,
            enable_hsl = true,
            enable_hsl_without_function = true,
            enable_ansi = true,
            enable_var_usage = true,
            enable_tailwind = true,
        })
    end,
})

-- =============================================================================
--                                   Blink
-- =============================================================================
local blink = require("blink.cmp")
blink.setup({
    keymap = { preset = "default" },
    sources = {
        default = { "lsp", "path" },
    },
    fuzzy = { implementation = "rust" },
})

-- =============================================================================
--                                 Treesitter
-- =============================================================================
require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- =============================================================================
--                                    Lsp
-- =============================================================================
require("fidget").setup({})

local border_opt = "single"

vim.diagnostic.config({
    float = { border = border_opt, focusable = true },
    virtual_text = true,
    signs = false,
})

local capabilities = blink.get_lsp_capabilities()

local servers = {
    "lua_ls",
    "rust_analyzer",
    "zls",
    "ts_ls",
    "nixd",
    "yamlls",
    "basedpyright",
    "gopls",
    "ocamllsp",
}

for _, server in ipairs(servers) do
    if (server == "nixd") then
        vim.lsp.config[server] = {
            capabilities = capabilities,
            cmd = { "nixd" },
            settings = {
                nixd = {
                    nixpkgs = {
                        expr = "import <nixpkgs> { }",
                    },
                },
            },
        }
    elseif (server == "lua_ls") then
        vim.lsp.config[server] = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        }
    else
        vim.lsp.config[server] = {
            capabilities = capabilities,
        }
    end

    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        keymap.set("n", "gt", function()
            vim.lsp.buf.type_definition()
        end, opts)
        keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = border_opt })
        end, opts)
        keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        keymap.set("n", "<leader>E", function()
            vim.diagnostic.open_float()
        end, opts)
    end,
})

-- =============================================================================
--                                  Fzf-lua
-- =============================================================================
require("fzf-lua").setup({
    defaults = { file_icons = false },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
})

keymap.set("n", "<leader>sf", ":FzfLua files<CR>", { silent = true })
keymap.set("n", "<leader>sg", ":FzfLua live_grep<CR>", { silent = true })
keymap.set("n", "<leader>sd", ":FzfLua lsp_workspace_diagnostics<CR>", { silent = true })

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
