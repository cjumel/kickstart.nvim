-- Harpoon
--
-- Harpoon is a plugin designed to get you where you want with the fewest keystrokes possible, creating a new workflow
-- to access instantaneously a few selected places (e.g. files, but not only). It is very complementary with Telescope
-- and Oil, as it makes possible to go back to any place previously visited without repeating the manual search for it.
-- Besides, it is very customizable, which allows for instance to add support for harpooning Oil buffers.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "º", function() require("harpoon"):list():prepend() end, desc = "Insert up in Harpoon list" }, -- <M-u>
    { "î", function() require("harpoon"):list():add() end, desc = "Insert down in Harpoon list" }, -- <M-i>
    {
      "Ì", -- <M-h>
      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
      desc = "Harpoon menu",
    },
    { "Ï", function() require("harpoon"):list():select(1) end, desc = "Go to Harpoon file 1" }, -- <M-j>
    { "È", function() require("harpoon"):list():select(2) end, desc = "Go to Harpoon file 2" }, -- <M-k>
    { "|", function() require("harpoon"):list():select(3) end, desc = "Go to Harpoon file 3" }, -- <M-l>
    { "µ", function() require("harpoon"):list():select(4) end, desc = "Go to Harpoon file 4" }, -- <M-m>
    { "∞", function() require("harpoon"):list():select(5) end, desc = "Go to Harpoon file 5" }, -- <M-,>
    { "…", function() require("harpoon"):list():select(6) end, desc = "Go to Harpoon file 6" }, -- <M-;>
    { "\\", function() require("harpoon"):list():select(7) end, desc = "Go to Harpoon file 7" }, -- <M-:>
    { "≠", function() require("harpoon"):list():select(8) end, desc = "Go to Harpoon file 8" }, -- <M-=>
  },
  opts = {
    settings = {
      save_on_toggle = true, -- Don't require to write in Harpoon menu to save changes
    },
    default = {
      display = function(item) -- Make item display more user-friendly
        local path = item.value
        path = path:gsub("oil://", "") -- Remove the Oil prefix if there is one
        return vim.fn.fnamemodify(path, ":p:~:.") -- Shorten path
      end,
    },
  },
  config = function(_, opts) require("harpoon"):setup(opts) end,
}
