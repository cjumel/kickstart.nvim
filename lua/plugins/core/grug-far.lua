-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible.

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "<leader>r", require("plugins.core.grug-far.actions").grug_far, mode = { "n", "v" }, desc = "[R]eplace" },
  },
  opts = {},
}
