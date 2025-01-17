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

-- Setup lazy.nvim
require("lazy").setup({
  spec = { -- Define the plugin specification groups to import
    { import = "plugins.colorschemes" },
    { import = "plugins.ui" }, -- User-Interface plugins (status line, icons, etc.)
    { import = "plugins.core" },
    { import = "plugins.vcs" }, -- Version-Control-System plugins (Git signs, Git conflicts, etc.)
    { import = "plugins.tools" }, -- External tool plugins, to bring extra features (debugger, database explorer, etc.)
  },
  rocks = { enabled = false }, -- Disable luarocks as it's not installed on my machine & I don't need it
  ui = { border = "rounded" }, -- Add a border in Lazy UI to improve visibility in transparent backgrounds
  change_detection = { enabled = false }, -- Don't automatically reload plugins when their config is updated
})
