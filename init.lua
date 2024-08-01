-- Set leader & local leader keys
-- This must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup `lazy.nvim` plugins and options
local plugins = {
  -- Color schemes plugins define the highlight groups used in the editor
  { import = "plugins.colorschemes" },

  -- Core plugins bring features to edit buffers efficiently (text objects, motions, LSP,
  -- formatters, etc.)
  { import = "plugins.core" },

  -- Tools plugins bring extra features not related directly to editing buffer (DAP, database
  -- explorer, etc.)
  { import = "plugins.tools" },

  -- User interface plugins bring various visual improvements (colorscheme, statusline, etc.)
  { import = "plugins.ui" },
}
local opts = {
  ui = { border = "rounded" }, -- Improve visibility with transparent background
  change_detection = { enabled = false },
}
require("lazy").setup(plugins, opts)

-- vim: ts=2 sts=2 sw=2 et
