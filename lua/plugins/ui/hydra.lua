-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define
-- sub-menus in Neovim, to make some actions simpler to use than through regular keymaps. For instance, it can make
-- possible to use window keymaps (increase height, decrease width, etc.) without having to repeat the window prefix
-- (<C-w>) between each action, which is a lot more convenient for me as I find the window prefix quite difficult to
-- type.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window Hydra" },
  },
  opts = {
    invoke_on_body = true, -- Invoke the Hydra directy after pressing the body key
    hint = { float_opts = { border = "rounded" } }, -- Add a border to improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    local Hydra = require("hydra")

    Hydra.setup(opts)

    -- Setup Hydras
    local hydra_configs = require("plugins.ui.hydra.configs")
    Hydra(hydra_configs.window)
  end,
}
