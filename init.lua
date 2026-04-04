vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.incsearch = true

vim.o.hlsearch = true
vim.o.inccommand = "split"

vim.o.title = true
vim.o.wrap = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.scrolloff = 10

vim.o.undofile = true
vim.o.autoread = true
vim.o.swapfile = false

vim.o.mouse = "a"
vim.o.clipboard = vim.o.clipboard .. "unnamed"
vim.o.guicursor = "n-v-i-c:block-Cursor"

vim.keymap.set("n", "<leader>p", "<C-^>")
vim.keymap.set("n", "<C-j>", ":cnext<CR>")
vim.keymap.set("n", "<C-k>", ":cprev<CR>")
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader>i", ":Inspect<CR>")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ocaml", "ocamlinterface", "ocamllex", "ocamlyacc" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust" },
    callback = function()
        vim.bo.textwidth = 80
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.cmd("hi! Cursor guibg=none")
    end,
})

-- perform the cursor clear.
vim.cmd.colorscheme("default")
vim.cmd.colorscheme("vscode")
vim.cmd("hi! @type.builtin gui=bold")

require('vim._core.ui2').enable({
    enable = true,
    msg = {
        target = 'msg',
        timeout = 4000,
    },
})

vim.api.nvim_create_autocmd('LspProgress',{
    callback = function(ev)
        local value = ev.data.params.value
        vim.api.nvim_echo({ { value.message or 'done' } }, false, {
            id = 'lsp.' .. ev.data.client_id,
            kind = 'progress',
            source = 'vim.lsp',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})

require("mini.trailspace").setup()
require("mini.align").setup()

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

local blink = require("blink.cmp")
blink.setup({
    keymap = { preset = "default" },
    sources = {
        default = { "lsp", "path" },
    },
    fuzzy = { implementation = "rust" },
})

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

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
    "basedpyright",
    "gopls",
    "ocamllsp",
}

vim.lsp.config["nixd"] = {
    cmd = { "nixd" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
        },
    },
}

vim.lsp.config["lua_ls"] = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
}

for _, server in ipairs(servers) do
    vim.lsp.config[server].capabilities = capabilities
    vim.lsp.enable(server)
end


vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "gt", function()
            vim.lsp.buf.type_definition()
        end, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = border_opt })
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("n", "<leader>E", function()
            vim.diagnostic.open_float()
        end, opts)

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

require("fzf-lua").setup({
    defaults = { file_icons = false },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
})

vim.keymap.set("n", "<leader>sf", ":FzfLua files<CR>", { silent = true })
vim.keymap.set("n", "<leader>sg", ":FzfLua live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>sd", ":FzfLua lsp_workspace_diagnostics<CR>", { silent = true })

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

vim.keymap.set("n", "<leader>n", ":Oil<CR>", { silent = true })
