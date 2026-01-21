return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" }, -- For the lualine.nvim component
  keys = {
    { "<M-p>", function() require("harpoon"):list():add() end, desc = "Pin file" },
    { "<M-u>", function() require("harpoon"):list():remove() end, desc = "Unpin file" },
    {
      "<M-l>",
      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
      desc = "List pinned files",
    },
    { "<M-1>", function() require("harpoon"):list():select(1) end, desc = "Open pinned file 1" },
    { "<M-2>", function() require("harpoon"):list():select(2) end, desc = "Open pinned file 2" },
    { "<M-3>", function() require("harpoon"):list():select(3) end, desc = "Open pinned file 3" },
    { "<M-4>", function() require("harpoon"):list():select(4) end, desc = "Open pinned file 4" },
    { "<M-5>", function() require("harpoon"):list():select(5) end, desc = "Open pinned file 5" },
    { "<M-6>", function() require("harpoon"):list():select(6) end, desc = "Open pinned file 6" },
    { "<M-7>", function() require("harpoon"):list():select(7) end, desc = "Open pinned file 7" },
    { "<M-8>", function() require("harpoon"):list():select(8) end, desc = "Open pinned file 8" },
    { "<M-9>", function() require("harpoon"):list():select(9) end, desc = "Open pinned file 9" },
    { "<M-0>", function() require("harpoon"):list():select(10) end, desc = "Open pinned file 10" },
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
