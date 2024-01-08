-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Harpoon file actions
    {
      "<leader>h",
      function()
        require("plugins.navigation.harpoon.utils.actions").add_mark(nil, { verbose = true })
      end,
      desc = "[H]ook with Harpoon",
    },
    {
      "<leader>H",
      function()
        require("plugins.navigation.harpoon.utils.actions").add_mark(
          nil,
          { verbose = true, clear_all = true }
        )
      end,
      desc = "[H]ook with Harpoon (overwrite)",
    },
    {
      "<leader>m",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "[M]enu with Harpoon",
    },

    -- Jump to Harpoon file
    {
      "gh",
      function()
        require("plugins.navigation.harpoon.utils.actions").go_to_mark(1)
      end,
      desc = "Go to Harpoon file 1",
    },
    {
      "gj",
      function()
        require("plugins.navigation.harpoon.utils.actions").go_to_mark(2)
      end,
      desc = "Go to Harpoon file 2",
    },
    {
      "gk",
      function()
        require("plugins.navigation.harpoon.utils.actions").go_to_mark(3)
      end,
      desc = "Go to Harpoon file 3",
    },
    {
      "gl",
      function()
        require("plugins.navigation.harpoon.utils.actions").go_to_mark(4)
      end,
      desc = "Go to Harpoon file 4",
    },
    {
      "gm",
      function()
        require("plugins.navigation.harpoon.utils.actions").go_to_mark(5)
      end,
      desc = "Go to Harpoon file 5",
    },
  },
}
