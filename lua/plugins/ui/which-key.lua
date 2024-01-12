-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

local utils = require("utils")

local overseer_keychains = require("plugins.external_tools.overseer.keychains")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<C-\\>", -- Actually <C-m> on my setup, like "mappings"
      function()
        vim.cmd("WhichKey '' n")
      end,
      mode = { "n" },
      desc = "Which key",
    },
    {
      "<C-\\>", -- Actually <C-m> on my setup, like "mappings"
      function()
        vim.cmd("WhichKey '' i")
      end,
      mode = { "i" },
      desc = "Which key",
    },
  },
  opts = {
    window = {
      border = "single",
    },
    layout = {
      width = {
        max = 75,
      },
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)

    -- document existing key chains
    require("which-key").register(utils.table.concat_dicts({
      {
        ["["] = { name = "Next", _ = "which_key_ignore" },
        ["]"] = { name = "Previous", _ = "which_key_ignore" },
        ["<C-w>"] = { name = "Window", _ = "which_key_ignore" },
        ["<leader>"] = { name = "Leader", _ = "which_key_ignore" },

        ["<leader>,"] = { name = "Settings", _ = "which_key_ignore" },
        ["<leader>?"] = { name = "Help", _ = "which_key_ignore" },
        ["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
        ["<leader>dp"] = { name = "[D]ebug [P]ython", _ = "which_key_ignore" },
        ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
        ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
        ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
        ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
      },
      overseer_keychains,
    }))
  end,
}
