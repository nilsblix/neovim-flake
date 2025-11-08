local cmd = vim.cmd
local opt = vim.o

opt.path = opt.path .. '**'

opt.number = true
opt.incsearch = true
opt.hlsearch = true
opt.guicursor = "n-v-i-c:block-Cursor"

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
cmd("set clipboard+=unnamed")

local keymap = vim.keymap
keymap.set("n", "<leader>p", "<C-^>")
keymap.set("n", "<leader>ya", "mzggyG`z")
keymap.set("n", "<C-c>", ":cnext<CR>")
keymap.set("n", "<C-k>", ":cprev<CR>")
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Remove italics
local grpid = vim.api.nvim_create_augroup('custom_highlights', {})
vim.api.nvim_create_autocmd('ColorScheme', {
    group = grpid,
    pattern = "*",
    callback = function(_)
        cmd("hi! Cursorline guibg=NONE")
        for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
            if ok and hl then
                if hl.italic or hl.underline or hl.undercurl or hl.underdouble or hl.underdotted or hl.underdashed then
                    hl.italic = false
                    vim.api.nvim_set_hl(0, name, hl)
                end
            end
        end
        vim.cmd("hi! clear Cursor")
    end,
})

function B(bg)
    cmd("hi! Normal guibg=" .. bg)
    cmd("hi! EndOfBuffer guibg=" .. bg)
    cmd("hi! LineNr guibg=" .. bg)
end

cmd("colorscheme sonokai")
vim.cmd("set notermguicolors")
-- I set these to disable highlights on FIXME, TODO or NOTE
cmd("hi! Todo ctermbg=none gui=none")
cmd("hi! @comment.error.comment ctermbg=none")
cmd("hi! @comment.note.comment ctermbg=none")

-- <=============== Blink ===============>
local blink = require("blink.cmp")
blink.setup({
    keymap = { preset = "default" },
    sources = {
        default = { "lsp", "path" },
    },
    fuzzy = { implementation = "rust" },
    completion = {
        menu = {
            draw = {
                columns = { { "label", "kind", gap = 1 }, { "label_description" } },
            }
        },
        documentation = { auto_show = true },
    }
})

-- <=============== Treesitter ===============>
require("nvim-treesitter.configs").setup({
    ensure_installed = {},
    sync_install = false,
    auto_install = false,
    indent = { enable = true, },
    highlight = { enable = true, },
})

-- <=============== Lsp ===============>
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
end

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
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

require("telescope").setup({
    defaults = {
        color_devicons = false,
    },
    pickers = {
        find_files = { disable_devicons = true },
        live_grep = { disable_devicons = true },
        diagnostics = { disable_devicons = true },
        buffers = { disable_devicons = true },
        grep_string = { disable_devicons = true },
        oldfiles = { disable_devicons = true },
        lsp_references = { disable_devicons = true },
    },
})
local telescope_builtin = require("telescope.builtin")
keymap.set("n", "<leader>sf", telescope_builtin.find_files)
keymap.set("n", "<leader>sg", telescope_builtin.live_grep)
keymap.set("n", "<leader>sd", telescope_builtin.diagnostics)

-- <=============== NvimTree ===============>
require("oil").setup({
    default_file_explorer = true,
    columns = {},
    view_options = { show_hidden = true },
})

keymap.set("n", "<leader>n", ":Oil<CR>")
