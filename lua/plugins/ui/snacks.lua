-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim. All these plugigns work very nicely
-- out-of-the-box, with great default behaviors, and bring many UI improvements as well as new cool atomic features.

local telescope_builtin = require("plugins.core.telescope.builtin")

return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 1000, -- Main UI stuff should be loaded first
  lazy = false,
  keys = {
    { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "[N]otifications" },
    { "<leader>z", function() require("snacks").zen() end, desc = "[Z]en mode" },
    { "<leader><BS>", function() require("snacks").bufdelete() end, desc = "Delete buffer" },
    { "<leader>go", function() require("snacks").gitbrowse() end, desc = "[G]it: [O]pen in browser" },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Current directory", action = function() require("oil").open() end },
        { icon = "󰊢 ", key = "n", desc = "Neogit", action = function() require("neogit").open() end },
        { icon = "󰚰 ", key = "g", desc = "Find Git Status Files", action = telescope_builtin.git_status },
        { icon = " ", key = "f", desc = "Find Files", action = telescope_builtin.find_files },
        { icon = " ", key = "d", desc = "Find Directories", action = telescope_builtin.find_directories },
        { icon = " ", key = "r", desc = "Find Recent files", action = telescope_builtin.recent_files },
        { icon = " ", key = "o", desc = "Find Old files", action = telescope_builtin.old_files },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    zen = {
      toggles = { dim = false },
      win = { width = 130 }, -- To support up until 120 line length
    },
    styles = {
      notification = { wo = { wrap = true } }, -- Don't truncate notifications
      notification_history = { wo = { number = false, relativenumber = false } },
      zen = { wo = { number = false, relativenumber = false, signcolumn = "no", colorcolumn = "" } },
    },
  },
}
