-- Window
vim.opt.showtabline = 1 -- Only when there are multiple tabs
vim.opt.laststatus = 3 -- Global status line accross windows
vim.opt.winborder = "rounded"
vim.opt.number = true
vim.opt.signcolumn = "number" -- Merge with number column
vim.opt.foldcolumn = "auto" -- Only when there are folds
vim.opt.fillchars = { foldopen = "", foldclose = "", fold = " " }
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Edition
vim.opt.iskeyword:append("-") -- Special characters allowed in word text object
vim.opt.matchpairs:append("<:>")
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Case-sensitive when using "\C" or capital letter
vim.opt.shortmess:append("S") -- Remove inline search count

-- Internals
vim.opt.exrc = true -- Enable secure project-local config files (e.g. via a `.nvim.lua` file)
vim.opt.undofile = true
vim.opt.updatetime = 300 -- Delay for writting swap files
vim.opt.timeoutlen = 300 -- Delay for mapped key sequences
vim.opt.diffopt = "internal,filler,closeoff" -- Remove linematch (for gitsigns.nvim hunk jumps)
vim.opt.complete = "" -- Disable builtin completion
vim.opt.completeopt = ""
vim.g.no_plugin_maps = 1 -- Disable builtin filetype plugin keymaps

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  float = { source = true },
  signs = {
    text = { -- From lualine.nvim
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
    },
  },
  virtual_text = true,
})

-- Filetypes
vim.filetype.add({
  pattern = {
    ["%.env%.%w+"] = "sh",
    ["%.env%..*%.%w+"] = "sh",
  },
  filename = {
    [".aliases"] = "sh",
    [".shellcheckrc"] = "conf",
    [".stow-local-ignore"] = "conf",
    ["ripgreprc"] = "conf",
  },
})

-- Warnings
if vim.g.disable_deprecation_warnings then
  vim.deprecate = function() end ---@diagnostic disable-line: duplicate-set-field
end

-- Theme-specific option overrides
if ThemeConfig.option_callback then
  ThemeConfig.option_callback()
end
