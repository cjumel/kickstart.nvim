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
      "<leader><CR>",
      function()
        require("plugins.navigation.harpoon.utils.actions").add_mark()
      end,
      desc = "Add Harpoon mark",
    },
    {
      "<leader>h",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "[H]arpoon: menu",
    },
    {
      "<leader>H",
      function()
        require("harpoon.mark").clear_all()
        print("Harpoon files cleared")
      end,
      desc = "[H]arpoon: clear",
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
