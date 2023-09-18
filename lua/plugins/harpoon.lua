-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  init = function()
    vim.keymap.set("n", "<leader>ha", function()
      require("harpoon.mark").add_file()
    end, { desc = "[H]arpoon: [A]dd file" })
    vim.keymap.set("n", "<leader>hm", function()
      require("harpoon.ui").toggle_quick_menu()
    end, { desc = "[H]arpoon: [M]enu" })
    vim.keymap.set("n", "gh", function()
      require("harpoon.ui").nav_file(1)
    end, { desc = "[G]o to harpoon file [H] (1)" })
    vim.keymap.set("n", "gj", function()
      require("harpoon.ui").nav_file(2)
    end, { desc = "[G]o to harpoon file [J] (2)" })
    vim.keymap.set("n", "gk", function()
      require("harpoon.ui").nav_file(3)
    end, { desc = "[G]o to harpoon file [K] (3)" })
    vim.keymap.set("n", "gl", function()
      require("harpoon.ui").nav_file(4)
    end, { desc = "[G]o to harpoon file [L] (4)" })
    vim.keymap.set("n", "gm", function()
      require("harpoon.ui").nav_file(5)
    end, { desc = "[G]o to harpoon file [M] (5)" })
  end,
}
