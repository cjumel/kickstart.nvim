-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- Global Harpoon action
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "[H]arpoon: [A]dd file",
    },
    {
      "<leader>hm",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "[H]arpoon: [M]enu",
    },

    -- Next/previous Harpoon file
    {
      "[h",
      function()
        require("harpoon.ui").nav_next()
      end,
      desc = "Next Harpoon file",
    },
    {
      "]h",
      function()
        require("harpoon.ui").nav_prev()
      end,
      desc = "Previous Harpoon file",
    },

    -- Jump to Harpoon file
    {
      "gh",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "[G]o to harpoon file [H] (1)",
    },
    {
      "gj",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "[G]o to harpoon file [J] (2)",
    },
    {
      "gk",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "[G]o to harpoon file [K] (3)",
    },
    {
      "gl",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "[G]o to harpoon file [L] (4)",
    },
    {
      "gm",
      function()
        require("harpoon.ui").nav_file(5)
      end,
      desc = "[G]o to harpoon file [M] (5)",
    },
  },
}
