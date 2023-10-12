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
        local idx = require("harpoon.mark").get_current_index()
        print("File " .. idx .. " added to Harpoon!")
      end,
      desc = "[H]arpoon: [A]dd file",
    },
    {
      "<leader>hr",
      function()
        local idx = require("harpoon.mark").get_current_index()
        require("harpoon.mark").rm_file()
        print("File " .. idx .. " removed from Harpoon!")
      end,
      desc = "[H]arpoon: [R]emove file",
    },
    {
      "<leader>hc",
      function()
        require("harpoon.mark").clear_all()
        print("Harpoon files cleared!")
      end,
      desc = "[H]arpoon: [C]lear files",
    },
    {
      "<leader>hm",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "[H]arpoon: [M]enu",
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
