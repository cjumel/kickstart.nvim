-- Harpoon
--
-- Enable harpooning files. Harpooned files can be accessed from anywhere and at all time
-- with a simple command.

-- Output true if the current file is in the Harpoon list, false otherwise
local function is_in_harpoon_list()
  local harpoon = require("harpoon")
  local oil = require("oil")

  -- Compute the path of the file or directory and format it like in Harpoon
  local path
  if vim.bo.filetype == "oil" then
    path = oil.get_current_dir()
    if path == nil then
      return
    end
  else
    path = vim.fn.expand("%:p")
  end
  path = vim.fn.fnamemodify(path, ":.")

  local harpoon_list_length = harpoon:list():length()
  for index = 1, harpoon_list_length do
    local harpoon_file_path = harpoon:list():get(index).value
    if path == harpoon_file_path then
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

    -- Config for default Harpoon list (for files)
    -- The following functions relies a lot on the original implementation, in harpoon.config
    default = {

      -- Overwrite action when item is added to the list, in order to handle both adding
      -- a regular buffer and a directory when in an Oil buffer
      create_list_item = function(config, name)
        if name == nil then
          -- Fetch the raw path depending on whether the current buffer is an Oil buffer or not
          if vim.bo.filetype == "oil" then
            name = require("oil").get_current_dir()
          else
            name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
          end

          name = require("plenary.path"):new(name):make_relative(config.get_root_dir())

          -- Append a slash to directory names for consistency with Oil
          if vim.bo.filetype == "oil" then
            name = name .. "/"
          end
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

      -- Overwrite action when selecting an item from the list, in order to handle both regular
      -- buffers and directories (opened with Oil)
      select = function(list_item, _, _)
        if list_item == nil then
          return
        end

        -- Since Oil buffers might be cleaned up, we need to re-open one
        -- We don't care about retrieving the right position as Oil buffers are often short
        if vim.fn.isdirectory(list_item.value) == 1 then
          require("oil").open(list_item.value)
          return
        end

        local bufnr = vim.fn.bufnr(list_item.value)
        local set_position = false
        if bufnr == -1 then
          set_position = true
          bufnr = vim.fn.bufnr(list_item.value, true)
        end
        if not vim.api.nvim_buf_is_loaded(bufnr) then
          vim.fn.bufload(bufnr)
          vim.api.nvim_set_option_value("buflisted", true, {
            buf = bufnr,
          })
        end

        vim.api.nvim_set_current_buf(bufnr)

        if set_position then
          vim.api.nvim_win_set_cursor(0, {
            list_item.context.row or 1,
            list_item.context.col or 0,
          })
        end
      end,
    },
  },
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)
  end,
}
