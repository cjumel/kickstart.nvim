-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

-- Output true if the current file is in the Harpoon list, false otherwise
local function is_in_harpoon_list()
  local harpoon = require("harpoon")

  local harpoon_list_length = harpoon:list():length()
  local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

  for index = 1, harpoon_list_length do
    local harpoon_file_path = harpoon:list():get(index).value
    if current_file_path == harpoon_file_path then
      return true
    end
  end

  return false
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "î", -- <M-i>
      function()
        local harpoon = require("harpoon")

        if is_in_harpoon_list() then
          harpoon:list():remove()
        else
          harpoon:list():append()
        end
      end,
      desc = "Append to Harpoon",
    },
    {
      "œ", -- <M-o>
      function()
        local harpoon = require("harpoon")

        if is_in_harpoon_list() then
          harpoon:list():remove()
        else
          harpoon:list():prepend()
        end
      end,
      desc = "Prepend to Harpoon",
    },
    {
      "©", -- <M-c>
      function()
        local harpoon = require("harpoon")
        harpoon:list():clear()
      end,
      desc = "Clear Harpoon",
    },
    {
      "Ì", -- <M-h>
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon menu",
    },
    {
      "Ï", -- <M-j>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(1)
      end,
      desc = "Go to Harpoon file 1",
    },
    {
      "È", -- <M-k>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(2)
      end,
      desc = "Go to Harpoon file 2",
    },
    {
      "|", -- <M-l>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(3)
      end,
      desc = "Go to Harpoon file 3",
    },
    {
      "µ", -- <M-m>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(4)
      end,
      desc = "Go to Harpoon file 4",
    },
    {
      "∞", -- <M-,>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(5)
      end,
      desc = "Go to Harpoon file 5",
    },
    {
      "…", -- <M-;>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(6)
      end,
      desc = "Go to Harpoon file 6",
    },
    {
      "\\", -- <M-\>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(7)
      end,
      desc = "Go to Harpoon file 7",
    },
    {
      "≠", -- <M-≠>
      function()
        local harpoon = require("harpoon")
        harpoon:list():select(8)
      end,
      desc = "Go to Harpoon file 8",
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
