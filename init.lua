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

-- Setup global variables for main configuration modules
Metaconfig = require("metaconfig")
Theme = require("theme")

-- Setup environment variables defined in `Metaconfig`
for key, value in pairs(Metaconfig.environment_variables or {}) do
  vim.fn.setenv(key, value)
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins.colorschemes" },
    { import = "plugins.ui" },
    { import = "plugins.core" },
    { import = "plugins.vcs" },
    { import = "plugins.tools" },
  },
  rocks = { enabled = false }, -- Luarocks is not installed on my machine & I don't need it
  ui = { border = "rounded" }, -- Better for transparent backgrounds
  change_detection = { enabled = false },
})
