return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>p", function() require("harpoon"):list():add() end, desc = "[P]in file" },
    {
      "<leader>à",
      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
      desc = "Pinned files",
    },
    -- Let's only show one entry in which-key.nvim for all the following keymaps
    { "<leader>&", function() require("harpoon"):list():select(1) end, desc = "Open pinned file 1~9" },
    { "<leader>é", function() require("harpoon"):list():select(2) end, desc = "<which-key-ignore>" },
    { '<leader>"', function() require("harpoon"):list():select(3) end, desc = "<which-key-ignore>" },
    { "<leader>'", function() require("harpoon"):list():select(4) end, desc = "<which-key-ignore>" },
    { "<leader>(", function() require("harpoon"):list():select(5) end, desc = "<which-key-ignore>" },
    { "<leader>§", function() require("harpoon"):list():select(6) end, desc = "<which-key-ignore>" },
    { "<leader>è", function() require("harpoon"):list():select(7) end, desc = "<which-key-ignore>" },
    { "<leader>!", function() require("harpoon"):list():select(8) end, desc = "<which-key-ignore>" },
    { "<leader>ç", function() require("harpoon"):list():select(9) end, desc = "<which-key-ignore>" },
  },
  opts = {
    settings = {
      save_on_toggle = true,
    },
    default = {
      display = function(item)
        local path = item.value:gsub("oil://", "")
        path = vim.fn.fnamemodify(path, ":p:~:.")
        return path ~= "" and path or vim.fn.fnamemodify(path, ":p:~")
      end,
    },
  },
  config = function(_, opts) require("harpoon"):setup(opts) end,
}
