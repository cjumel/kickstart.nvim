-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup global variables for main configuration modules
MetaConfig = require("config.meta")
ThemeConfig = require("config.theme")
Lazy = require("lazy")

-- Setup leader and local leader keys before loading lazy.nvim so that mappings are correct in plugins setup
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- Setup background category from current theme, so that plugins can use it
vim.opt.background = ThemeConfig.background or "dark"

-- Setup lazy.nvim
Lazy.setup({
  spec = {
    { import = "plugins.colorschemes" },
    { import = "plugins.ui" },
    { import = "plugins.core" },
    { import = "plugins.vcs" },
    { import = "plugins.tools" },
  },
  rocks = { enabled = false }, -- Luarocks is not installed on my machine & I don't need it
  ui = { border = "rounded" },
  change_detection = { enabled = false },
})

-- Customize lazy.nvim UI window keymaps
local lazy_view_config = require("lazy.view.config")
lazy_view_config.keys.next = ","
lazy_view_config.keys.prev = ";"
