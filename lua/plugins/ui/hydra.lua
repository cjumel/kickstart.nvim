-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define
-- sub-menus in Neovim, to make some actions simpler to use than through regular keymaps. For instance, it can make
-- possible to use window keymaps (increase height, decrease width, etc.) without having to type the window prefix
-- (<C-w>) between each single action, which is a lot more convenient.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window Hydra" },
    { "<leader>,", desc = "Option Hydra" },
  },
  init = function()
    -- Initialize global variables for the option Hydra
    -- When changing any option below, the relevant options or plugin behavior must also be changed
    -- Neovim options, default behavior is defined in `plugin/options.lua`
    vim.g.color_column_mode = "auto" -- "auto", "88" (Ruff default), "100", "120" (Stylua default), "140", "off"
    vim.g.number_column_mode = "absolute" -- "absolute", "relative", "off"
    vim.g.concealing_mode = "auto" -- "auto", "on", "off"
    vim.g.sign_column_mode = "number" -- "number", "yes", "off"
    -- Plugin options, default behavior is defined in the relevant plugin config in `lua/plugins/`
    vim.g.disable_autopairs = false
    vim.g.disable_format_on_save = false
    vim.g.disable_github_copilot = false
    vim.g.disable_lint = false
    vim.g.disable_treesitter_context = true
  end,
  opts = {
    invoke_on_body = true,
    hint = { float_opts = { border = "rounded" } }, -- Improve visibility with transparent background
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    local hydra_configs = require("plugins.ui.hydra.configs")

    Hydra.setup(opts)

    -- Setup general Hydras
    Hydra(hydra_configs.window)
    Hydra(hydra_configs.option)
  end,
}
