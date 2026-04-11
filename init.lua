vim.o.number = true
vim.o.title = true
vim.o.wrap = false
vim.opt.showtabline = 2
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.scrolloff = 10
vim.o.undofile = true
vim.o.autoread = true
vim.o.swapfile = false
vim.o.mouse = "a"
vim.o.clipboard = vim.o.clipboard .. "unnamed"
vim.o.guicursor = "n-v-i-c:block-Cursor"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>p", "<C-^>")
map("n", "<C-j>", ":cnext<CR>")
map("n", "<C-k>", ":cprev<CR>")
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
map("n", "<leader>i", ":Inspect<CR>")

for i = 1, 8 do
	map({ "n", "t" }, "<leader>" .. i, ":tabnext " .. i .. "<CR>")
end

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

local function apply_embark_blink_highlights()
    local palette = {
        space2 = "#2F2A47",
        space3 = "#3E3859",
        astral0 = "#8A889D",
        purple = "#d4bfff",
        dark_yellow = "#F2B482",
    }

    local set_hl = vim.api.nvim_set_hl

    set_hl(0, "PmenuKind", { fg = palette.purple, bg = palette.space2 })
    set_hl(0, "PmenuExtra", { fg = palette.astral0, bg = palette.space2 })
    set_hl(0, "LspSignatureActiveParameter", {
        fg = palette.dark_yellow,
        bg = palette.space2,
        bold = true,
        underline = true,
    })

    local links = {
        BlinkCmpLabelDeprecated = "PmenuExtra",
        BlinkCmpLabelDetail = "PmenuExtra",
        BlinkCmpLabelDescription = "PmenuExtra",
        BlinkCmpSource = "PmenuExtra",
        BlinkCmpKind = "PmenuKind",
        BlinkCmpKindText = "BlinkCmpKind",
        BlinkCmpKindMethod = "BlinkCmpKind",
        BlinkCmpKindFunction = "BlinkCmpKind",
        BlinkCmpKindConstructor = "BlinkCmpKind",
        BlinkCmpKindField = "BlinkCmpKind",
        BlinkCmpKindVariable = "BlinkCmpKind",
        BlinkCmpKindClass = "BlinkCmpKind",
        BlinkCmpKindInterface = "BlinkCmpKind",
        BlinkCmpKindModule = "BlinkCmpKind",
        BlinkCmpKindProperty = "BlinkCmpKind",
        BlinkCmpKindUnit = "BlinkCmpKind",
        BlinkCmpKindValue = "BlinkCmpKind",
        BlinkCmpKindEnum = "BlinkCmpKind",
        BlinkCmpKindKeyword = "BlinkCmpKind",
        BlinkCmpKindSnippet = "BlinkCmpKind",
        BlinkCmpKindColor = "BlinkCmpKind",
        BlinkCmpKindFile = "BlinkCmpKind",
        BlinkCmpKindReference = "BlinkCmpKind",
        BlinkCmpKindFolder = "BlinkCmpKind",
        BlinkCmpKindEnumMember = "BlinkCmpKind",
        BlinkCmpKindConstant = "BlinkCmpKind",
        BlinkCmpKindStruct = "BlinkCmpKind",
        BlinkCmpKindEvent = "BlinkCmpKind",
        BlinkCmpKindOperator = "BlinkCmpKind",
        BlinkCmpKindTypeParameter = "BlinkCmpKind",
        BlinkCmpScrollBarThumb = "PmenuThumb",
        BlinkCmpScrollBarGutter = "PmenuSbar",
        BlinkCmpGhostText = "NonText",
        BlinkCmpMenu = "Pmenu",
        BlinkCmpMenuSelection = "PmenuSel",
        BlinkCmpDoc = "NormalFloat",
        BlinkCmpDocCursorLine = "Visual",
        BlinkCmpSignatureHelp = "NormalFloat",
        BlinkCmpSignatureHelpActiveParameter = "LspSignatureActiveParameter",
    }

    for group, target in pairs(links) do
        set_hl(0, group, { link = target })
    end

    set_hl(0, "BlinkCmpMenuBorder", { fg = palette.space3, bg = palette.space2 })
    set_hl(0, "BlinkCmpDocBorder", { fg = palette.space3, bg = palette.space2 })
    set_hl(0, "BlinkCmpDocSeparator", { fg = palette.space3, bg = palette.space2 })
    set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = palette.space3, bg = palette.space2 })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function(args)
        vim.cmd("hi! Cursor guibg=none")

        if args.match == "embark" then
            apply_embark_blink_highlights()
        end
    end,
})

vim.cmd.colorscheme("embark")
apply_embark_blink_highlights()
vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

require('vim._core.ui2').enable({
    enable = true,
    msg = { target = 'msg', timeout = 4000 },
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
        map("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        map("n", "gt", function()
            vim.lsp.buf.type_definition()
        end, opts)
        map("n", "K", function()
            vim.lsp.buf.hover({ border = border_opt })
        end, opts)
        map("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        map("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        map("n", "<leader>E", function()
            vim.diagnostic.open_float()
        end, opts)

        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- client.server_capabilities.semanticTokensProvider = nil
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

map("n", "<leader>sf", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>sg", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>sd", ":FzfLua lsp_workspace_diagnostics<CR>", { silent = true })

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

map("n", "<leader>n", ":Oil<CR>", { silent = true })
