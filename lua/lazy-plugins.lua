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
    border = "rounded", -- Adding a border is lot better for transparent background
  },
  change_detection = {
    enabled = false,
  },
}

local plugins = {

  -- Plugins related to code (LSP, completion, debugging, etc.)
  { import = "plugins.code.dap" },
  { import = "plugins.code" },

  -- Plugins related to simple editions (highlighting, motions, text objects, etc.)
  { import = "plugins.edition.treesitter" },
  { import = "plugins.edition" },

  -- Plugins related to external tools (VCS, pre-commit, external package manager, etc.)
  { import = "plugins.external_tools.vim-dadbod" },
  { import = "plugins.external_tools" },

  -- Plugins related to code navigation (fuzzy finding, file tree navigation, etc.)
  { import = "plugins.navigation" },

  -- Plugins related to the user interface (color scheme, visual elements, etc.)
  { import = "plugins.ui" },
}

require("lazy").setup(plugins, opts)

-- vim: ts=2 sts=2 sw=2 et
