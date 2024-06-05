-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define
-- sub-menus in Neovim, to make some actions simpler to use than through regular keymaps. For instance, it can make
-- possible to use window keymaps (increase height, decrease width, etc.) without having to type the window prefix
-- (<C-w>) between each single action, which is a lot more convenient.

-- TODO: some small improvements can be made on the Hydra config:
--  - improve the option manager:
--    - change the treesitter context to use the "t" keymap & be in the plugin section
--    - try to improve the concealing keymap for something more mnemonic
--    - add a cursorline parameter
--    - add manual ruler column length (current mode could be named "auto")
--    - support auto, on, off options for conform
--    - support auto, on, off options for lint

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window Hydra" },
    { "<leader>,", desc = "Option Hydra" },
  },
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
