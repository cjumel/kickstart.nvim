-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define sub-menus
-- in Neovim, to make a set of actions a lot simpler to use than through regular keymaps, as there's no need to repeat
-- the common prefix in between the actions.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window Hydra" },
    { "<leader>d", desc = "Debug Hydra" },
    { "<leader>h", desc = "Hunk Hydra" },
    { "<leader>gc", desc = "Git conflict Hydra" },
  },
  opts = {
    invoke_on_body = true,
    hint = { float_opts = { border = "rounded" } }, -- Improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    require("hydra").setup(opts)

    -- Setup the different Hydras
    require("plugins.ui.hydra.window_hydra")
    require("plugins.ui.hydra.debug_hydra")
    require("plugins.ui.hydra.hunk_hydra")
    require("plugins.ui.hydra.git_conflict_hydra")
  end,
}
