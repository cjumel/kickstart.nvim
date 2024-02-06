-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>h",
      function()
        local harpoon = require("harpoon")
        harpoon:list():append()
      end,
      desc = "[H]arpoon file",
    },
    {
      "<leader>H",
      function()
        local harpoon = require("harpoon")
        harpoon:list():clear()
        harpoon:list():append()
      end,
      desc = "[H]arpoon file and overwrite",
    },
    {
      "<leader>m",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "[M]enu with Harpoon",
    },
    {
      "gh",
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(1)
      end,
      desc = "Go to Harpoon file 1",
    },
    {
      "gj",
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(2)
      end,
      desc = "Go to Harpoon file 2",
    },
    {
      "gk",
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(3)
      end,
      desc = "Go to Harpoon file 3",
    },
    {
      "gl",
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(4)
      end,
      desc = "Go to Harpoon file 4",
    },
    {
      "gm",
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(5)
      end,
      desc = "Go to Harpoon file 5",
    },
  },
  opts = {
    settings = {
      save_on_toggle = true,
    },
    default = { -- Config for default Harpoon list (for files)
      -- Overwrite action when item is added to the list, in order to handle the special case
      -- where we want to add the file under the cursor when in Oil buffer
      create_list_item = function(config, name)
        if name == nil then
          local absolute_path
          if vim.bo.filetype == "oil" then
            local entry = require("oil").get_cursor_entry()
            if entry == nil or entry.type == "directory" then
              return
            end
            local dir = require("oil").get_current_dir()
            absolute_path = dir .. entry.name
          else
            absolute_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
          end
          -- Re-implement the normalize_path function from harpoon.config
          name = require("plenary.path"):new(absolute_path):make_relative(config.get_root_dir())
        end

        local bufnr = vim.fn.bufnr(name, false)
        local pos = { 1, 0 }
        if bufnr ~= -1 then
          pos = vim.api.nvim_win_get_cursor(0)
        end

        return {
          value = name,
          context = {
            row = pos[1],
            col = pos[2],
          },
        }
      end,
    },
  },
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)
  end,
}
