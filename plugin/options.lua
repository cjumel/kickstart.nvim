-- [[ Options ]]

-- Global UI
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- After a line wrap, indent the part on the new virtual line
vim.o.splitright = true -- Open new vertical split window on the right
vim.o.splitbelow = true -- Open new horizontal split window below
vim.opt.cursorline = true -- Highlight the cursor line
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add recognized character pair

-- Side column
vim.wo.number = true -- Enable absolute line numbering
vim.wo.signcolumn = "number" -- Add signs in the number column

-- Search & replace
vim.o.ignorecase = true -- Make search case-insensitive by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Highlight matches during search
vim.opt.inccommand = "split" -- Preview modifications in split during incremental commands

-- Disable builtin auto-completion
vim.o.complete = ""
vim.o.completeopt = ""

-- Internals
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences

-- [[ Diagnostics ]]

-- Diagnostics configuration
vim.diagnostic.config({
  float = { border = "rounded" }, -- Better for transparent backgrounds
  severity_sort = true, -- Display most severe diagnostic in sign column
})

-- Use symbols taken from lualine/components/diagnostics/config.lua in sign column
for type, icon in pairs({ Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- [[ Filetypes ]]

-- Add custom filetypes to those known by Neovim
vim.filetype.add({
  filename = {
    [".env.example"] = "sh", -- same as `.env`
    [".env.sample"] = "sh", -- same as `.env`
    [".env.test"] = "sh", -- same as `.env`
    [".env.test.example"] = "sh", -- same as `.env`
    [".ideavimrc"] = "vim",
    [".markdownlintrc"] = "json", -- could also be "ini"
    [".prettierignore"] = "conf", -- auto-detected by nvim
    [".shellcheckrc"] = "conf", -- auto-detected by nvim
    [".stow-global-ignore"] = "conf", -- auto-detected by nvim
    [".stow-local-ignore"] = "conf", -- auto-detected by nvim
    [".vimiumrc"] = "vim",
    ["ignore"] = "conf", -- auto-detected by nvim
    ["ripgreprc"] = "conf", -- auto-detected by nvim
  },
})
