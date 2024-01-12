-- mason.nvim
--
-- Mason.nvim is a portable package manager for Neovim written in Lua.
-- In this implementation, packages are installed in two ways: packages defined in
-- `ensure_installed` are installed by running `:MasonInstallAll`, and packages defined in
-- the LSP configuration are automatically installed when the LSP server is initialized.

return {
  "williamboman/mason.nvim",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonInstallAll", -- Custom command to install all Mason packages (taken from NvChad)
  },
  opts = {
    ui = {
      border = "single",
    },
    ensure_installed = {
      -- Lua
      "lua-language-server", -- "lua_ls"
      "stylua",
      -- Python
      "pyright",
      "black",
      "ruff",
      "debugpy",
      -- Other
      "prettier",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Custom command to install all Mason packages (taken from NvChad)
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
    end, { desc = "Install all Mason packages." })

    vim.g.mason_binaries_list = opts.ensure_installed
  end,
}
