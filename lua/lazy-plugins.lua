-- [[ Install `lazy.nvim` plugin manager ]]

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

-- [[ Setup `lazy.nvim` & its plugins ]]

local opts = {
  ui = {
    border = "rounded", -- Improve visibility with transparent background
  },
  change_detection = {
    enabled = false,
  },
}

local plugins = {
  -- Core plugins bring features to edit buffers efficiently (text objects, motions, LSP,
  -- formatters, etc.)
  { import = "plugins.core" },

  -- Navigation plugins enable fast navigation and exploration between files (file fuzzy finding,
  -- file explorer, etc.) but also various navigation interfaces
  { import = "plugins.navigation" },

  -- Tools plugins bring extra features not related directly to editing buffer (DAP, database
  -- explorer, etc.)
  { import = "plugins.tools" },

  -- User interface plugins bring various visual improvements (colorscheme, statusline, etc.)
  { import = "plugins.ui" },
}

require("lazy").setup(plugins, opts)

-- vim: ts=2 sts=2 sw=2 et
