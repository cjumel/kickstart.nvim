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
        require("plugins.harpoon.utils.mark").add_harpoon_file()
      end,
      desc = "[H]arpoon: [A]dd file",
    },
    {
      "<leader>hr",
      function()
        require("plugins.harpoon.utils.mark").remove_harpoon_file()
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
        require("plugins.harpoon.utils.mark").go_to_harpoon_file(1)
      end,
      desc = "Goto Harpoon file 1",
    },
    {
      "gj",
      function()
        require("plugins.harpoon.utils.mark").go_to_harpoon_file(2)
      end,
      desc = "Goto Harpoon file 2",
    },
    {
      "gk",
      function()
        require("plugins.harpoon.utils.mark").go_to_harpoon_file(3)
      end,
      desc = "Goto Harpoon file 3",
    },
    {
      "gl",
      function()
        require("plugins.harpoon.utils.mark").go_to_harpoon_file(4)
      end,
      desc = "Goto Harpoon file 4",
    },
    {
      "gm",
      function()
        require("plugins.harpoon.utils.mark").go_to_harpoon_file(5)
      end,
      desc = "Goto Harpoon file 5",
    },
  },
  config = function()
    -- Define custom keymaps for quick menu
    local group = vim.api.nvim_create_augroup("Harpoon Augroup", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "harpoon",
      group = group,
      callback = function()
        vim.keymap.set("n", "=", function()
          require("harpoon.ui").select_menu_item()
        end, { noremap = true, silent = true })
      end,
    })
  end,
}
