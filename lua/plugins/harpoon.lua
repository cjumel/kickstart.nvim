-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- Harpoon in-file actions
    {
      "<leader>ha",
      function()
        local idx = require("harpoon.mark").get_current_index()
        if idx ~= nil then
          print("File already in Harpoon as file " .. idx)
          return
        end

        require("harpoon.mark").add_file()
        idx = require("harpoon.mark").get_current_index()
        print("File " .. idx .. " added to Harpoon")
      end,
      desc = "[H]arpoon: [A]dd file",
    },
    {
      "<leader>hr",
      function()
        local idx = require("harpoon.mark").get_current_index()
        if idx == nil then
          print("File not in Harpoon")
          return
        end

        require("harpoon.mark").rm_file()
        print("File " .. idx .. " removed from Harpoon")
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
        require("harpoon.ui").nav_file(1)
      end,
      desc = "Go to Harpoon file 1",
    },
    {
      "gj",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "Go to Harpoon file 2",
    },
    {
      "gk",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "Go to Harpoon file 3",
    },
    {
      "gl",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "Go to Harpoon file 4",
    },
    {
      "gm",
      function()
        require("harpoon.ui").nav_file(5)
      end,
      desc = "Go to Harpoon file 5",
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
