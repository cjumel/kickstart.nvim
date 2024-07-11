-- Harpoon
--
-- Harpoon is a plugin designed to get you where you want with the fewest keystrokes, creating a new workflow to access
-- instantaneously a few selected files. It is very complementary with Telescope & Oil, as it makes possible to go back
-- to any file previously opened without repeating the manual search for it. Besides, it is very customizable, which
-- allows for instance to add support for harpooning Oil buffers.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  -- FIXME: when updating beyond this commit, some issues appeared
  --  - the base features are broken and need fixing (manageable)
  --  - Harpoon's behavior changed (allowing for holes in Harpoon list)
  --  - for an obscure reason, the hop.nvim text-objects are completely broken
  commit = "a38be6e0dd4c6db66997deab71fc4453ace97f9c",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local harpoon = require("harpoon")
    local utils = require("utils")

    --- Output true if the current file is in the Harpoon list, false otherwise.
    ---@return boolean
    local function is_in_harpoon_list()
      local harpoon_list_length = harpoon:list():length()
      for index = 1, harpoon_list_length do
        local harpoon_item = harpoon:list():get(index)
        if harpoon_item ~= nil and utils.path.get_current_buffer_path() == harpoon_item.value then
          return true
        end
      end
      return false
    end

    return {
      {
        "î", -- <M-i>
        function()
          if vim.bo.filetype ~= "oil" and utils.buffer.is_temporary() then
            vim.notify("Cannot add temporary buffer to Harpoon", vim.log.levels.WARN)
          elseif is_in_harpoon_list() then
            harpoon:list():remove()
          else
            harpoon:list():append()
          end
        end,
        desc = "Insert in Harpoon list",
      },
      {
        "º", -- <M-u>
        function()
          if vim.bo.filetype ~= "oil" and utils.buffer.is_temporary() then
            vim.notify("Cannot add temporary buffer to Harpoon", vim.log.levels.WARN)
          elseif is_in_harpoon_list() then
            harpoon:list():remove()
          else
            harpoon:list():prepend()
          end
        end,
        desc = "Insert at upmost position in Harpoon list",
      },
      { "©", function() harpoon:list():clear() end, desc = "Clear Harpoon" }, -- <M-c>
      { "Ì", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" }, -- <M-h>
      { "Ï", function() harpoon:list():select(1) end, desc = "Go to Harpoon file 1" }, -- <M-j>
      { "È", function() harpoon:list():select(2) end, desc = "Go to Harpoon file 2" }, -- <M-k>
      { "|", function() harpoon:list():select(3) end, desc = "Go to Harpoon file 3" }, -- <M-l>
      { "µ", function() harpoon:list():select(4) end, desc = "Go to Harpoon file 4" }, -- <M-m>
      { "∞", function() harpoon:list():select(5) end, desc = "Go to Harpoon file 5" }, -- <M-,>
      { "…", function() harpoon:list():select(6) end, desc = "Go to Harpoon file 6" }, -- <M-;>
      { "\\", function() harpoon:list():select(7) end, desc = "Go to Harpoon file 7" }, -- <M-:>
      { "≠", function() harpoon:list():select(8) end, desc = "Go to Harpoon file 8" }, -- <M-=>
    }
  end,
  opts = {
    settings = { save_on_toggle = true },

    -- Config for default Harpoon list (for files)
    -- The following functions relies a lot on the original implementation, in harpoon.config
    default = {

      -- Overwrite action when item is added to the list, in order to handle both adding
      -- a regular buffer and a directory when in an Oil buffer
      create_list_item = function(_, name)
        if name == nil then
          name = require("utils").path.get_current_buffer_path()
          if name == nil then
            return
          end
        end

        local bufnr = vim.fn.bufnr(name, false)
        local pos = { 1, 0 }
        if bufnr ~= -1 then
          pos = vim.api.nvim_win_get_cursor(0)
        end

        return {
          value = name,
          context = { row = pos[1], col = pos[2] },
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
        -- vim.fn.isdirectory doesn't work for directories outside cwd
        if vim.fn.filereadable(list_item.value) ~= 1 then
          require("oil").open(list_item.value)
          return
        end

        local bufnr = vim.fn.bufnr(list_item.value)
        local set_position = false
        local reload = false -- Dirty fix to trigger ftplugins on file directly opened with Harpoon
        if bufnr == -1 then
          set_position = true
          bufnr = vim.fn.bufnr(list_item.value, true)
        end
        if not vim.api.nvim_buf_is_loaded(bufnr) then
          vim.fn.bufload(bufnr)
          vim.api.nvim_set_option_value("buflisted", true, { buf = bufnr })
          reload = true
        end

        vim.api.nvim_set_current_buf(bufnr)

        if set_position then
          vim.api.nvim_win_set_cursor(0, { list_item.context.row or 1, list_item.context.col or 0 })
        end
        if reload then
          vim.cmd("edit")
        end
      end,
    },
  },
  config = function(_, opts) require("harpoon"):setup(opts) end,
}
