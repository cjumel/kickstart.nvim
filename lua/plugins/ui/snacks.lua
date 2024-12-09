-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim.

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "[N]otifications" },
  },
  opts = {
    notifier = { enabled = true },
  },
}
