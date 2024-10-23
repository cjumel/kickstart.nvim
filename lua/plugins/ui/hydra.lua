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
    { "<leader>;", desc = "Window Hydra" },
    { "<leader>h", desc = "Hunk Hydra" },
  },
  opts = {
    invoke_on_body = true, -- Invoke the Hydra directy after pressing the body key
    hint = { float_opts = { border = "rounded" } }, -- Add a border to improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    require("hydra").setup(opts)

    -- Setup the different Hydras
    require("plugins.ui.hydra.window_hydra")
    require("plugins.ui.hydra.hunk_hydra")
  end,
}
