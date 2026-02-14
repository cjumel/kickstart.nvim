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

-- Setup leader and local leader keys before loading lazy.nvim so that mappings are correct in plugins setup
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- Setup background category from current theme, so that plugins can use it
ThemeConfig = require("config.theme")
vim.opt.background = ThemeConfig.background

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins.colorschemes" },
    { import = "plugins.ui" },
    { import = "plugins.core" },
    { import = "plugins.tools" },
  },
  rocks = { enabled = false }, -- Luarocks is not installed on my machine & I don't need it
  ui = { border = "rounded" },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "netrwPlugin",
        "osc52",
        "rplugin",
        "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Securely source machine-level configuration file
local global_config_path = vim.fn.stdpath("config") .. "/.nvim-global.lua"
if vim.fn.filereadable(global_config_path) == 1 then
  local code = vim.secure.read(global_config_path) -- User is prompted before reading the file
  if code ~= nil then
    load(code --[[@as string]])()
  end
end
