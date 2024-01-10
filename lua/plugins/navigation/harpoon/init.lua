-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

local harpoon_mark = require("plugins.navigation.harpoon.mark")

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
        harpoon_mark.add(nil, { verbose = true })
      end,
      desc = "[H]ook with Harpoon",
    },
    {
      "<leader>H",
      function()
        harpoon_mark.add(nil, { verbose = true, clear_all = true })
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
        harpoon_mark.go_to(1)
      end,
      desc = "Go to Harpoon file 1",
    },
    {
      "gj",
      function()
        harpoon_mark.go_to(2)
      end,
      desc = "Go to Harpoon file 2",
    },
    {
      "gk",
      function()
        harpoon_mark.go_to(3)
      end,
      desc = "Go to Harpoon file 3",
    },
    {
      "gl",
      function()
        harpoon_mark.go_to(4)
      end,
      desc = "Go to Harpoon file 4",
    },
    {
      "gm",
      function()
        harpoon_mark.go_to(5)
      end,
      desc = "Go to Harpoon file 5",
    },
  },
}
