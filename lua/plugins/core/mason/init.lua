-- mason.nvim
--
-- Mason.nvim is a portable package manager for Neovim written in Lua.

return {
  "williamboman/mason.nvim",
  cmd = {
    "Mason",
    "MasonUpdate",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
  },
  opts = {
    ui = {
      border = "rounded", -- A border is better for transparent backgrounds
    },
  },
}
