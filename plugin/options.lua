-- Window
vim.o.showtabline = 1 -- Show tabline only when there are multiple tabs
vim.o.laststatus = 3 -- Global status line for all windows
vim.wo.number = true -- Absolute line numbering
vim.wo.signcolumn = "number" -- Merge sign and number columns together
vim.opt.foldcolumn = "auto" -- Show fold column only when there are folds
vim.opt.fillchars = { foldopen = "", foldclose = "", fold = " " } -- Improve fold appearance
vim.opt.cursorline = true -- Highlight the cursor line
vim.opt.showmode = false -- Don't show mode in status line (done with lualine.nvim instead)

-- Editor
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- After a line wrap, indent the part on the new virtual line
vim.o.winborder = "rounded" -- Use rounded borders for floating windows
vim.o.splitright = true -- Open new vertical split window on the right
vim.o.splitbelow = true -- Open new horizontal split window below
vim.opt.pumheight = 30 -- Maximum number of items to show in the popup menu (e.g. for completion)
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add recognized character pair

-- Search
vim.o.ignorecase = true -- Case-insensitive searching by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Highlight matches during search
vim.opt.shortmess:append("S") -- Remove inline search count during searching (done with lualine.nvim instead)

-- Internals
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences
vim.o.diffopt = "internal,filler,closeoff" -- Remove linematch from diffopt (important for gitsigns.nvim hunk jumps)
vim.o.complete = "" -- Disable builtin auto-completion
vim.o.completeopt = "" -- Remove builtin auto-completion options

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  float = { source = "if_many" },
  signs = {
    text = { -- Set lualine.nvim diagnostic symbols (taken from lualine/components/diagnostics/config.lua)
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
    },
  },
  virtual_text = true,
})

-- Theme-specific options
if ThemeConfig.options_callback then -- Additional theme options setting
  ThemeConfig.options_callback()
end

-- Extra filetypes detection
vim.filetype.add({ filename = MetaConfig.extra_filename_to_filetype })
