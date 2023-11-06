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
    -- Harpoon in-file actions
    {
      "<leader>ha",
      function()
        require("plugins.navigation.utils.harpoon").add_harpoon_file()
      end,
      desc = "[H]arpoon: [A]dd file",
    },
    {
      "<leader>hr",
      function()
        require("plugins.navigation.utils.harpoon").remove_harpoon_file()
      end,
      desc = "[H]arpoon: [R]emove file",
    },
    {
      "<leader>hc",
      function()
        require("harpoon.mark").clear_all()
        print("Harpoon files cleared")
      end,
      desc = "[H]arpoon: [C]lear files",
    },

    -- Harpoon menu
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
        require("plugins.navigation.utils.harpoon").go_to_harpoon_file(1)
      end,
      desc = "Goto Harpoon file 1",
    },
    {
      "gj",
      function()
        require("plugins.navigation.utils.harpoon").go_to_harpoon_file(2)
      end,
      desc = "Goto Harpoon file 2",
    },
    {
      "gk",
      function()
        require("plugins.navigation.utils.harpoon").go_to_harpoon_file(3)
      end,
      desc = "Goto Harpoon file 3",
    },
    {
      "gl",
      function()
        require("plugins.navigation.utils.harpoon").go_to_harpoon_file(4)
      end,
      desc = "Goto Harpoon file 4",
    },
    {
      "gm",
      function()
        require("plugins.navigation.utils.harpoon").go_to_harpoon_file(5)
      end,
      desc = "Goto Harpoon file 5",
    },
  },
}
