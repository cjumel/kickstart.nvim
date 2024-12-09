-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim.

local telescope_builtin = require("plugins.core.telescope.builtin")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "[N]otifications" },
  },
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰊢 ", key = "g", desc = "Git status files", action = telescope_builtin.git_status },
        { icon = " ", key = "f", desc = "Find Files", action = telescope_builtin.find_files },
        { icon = " ", key = "d", desc = "Find Directories", action = telescope_builtin.find_directories },
        { icon = " ", key = "r", desc = "Find Recent files", action = telescope_builtin.recent_files },
        { icon = " ", key = "o", desc = "Find Old files", action = telescope_builtin.old_files },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    notifier = { enabled = true },
  },
}
