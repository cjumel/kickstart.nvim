-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "ThePrimeagen/harpoon",
  },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "[-] Open parent directory",
    },
  },
  opts = {
    default_file_explorer = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<tab>"] = "actions.preview",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["R"] = "actions.refresh",
      -- Overwrite Harpoon keymaps to add/remove the file under the cursor in Oil buffer instead
      -- of Oil buffer itself
      ["<leader>ha"] = function()
        local entry = require("oil").get_cursor_entry()
        if entry == nil then
          return
        end
        local dir = require("oil").get_current_dir()
        local path = dir .. entry.name
        require("plugins.harpoon.utils.mark").add_harpoon_file(path)
      end,
      ["<leader>hr"] = function()
        local entry = require("oil").get_cursor_entry()
        if entry == nil then
          return
        end
        local dir = require("oil").get_current_dir()
        local path = dir .. entry.name
        require("plugins.harpoon.utils.mark").remove_harpoon_file(path)
      end,
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_always_hidden = function(name, _)
        local always_hidden_names = {
          ".git",
          ".DS_Store",
          "__pycache__",
        }
        for _, always_hidden_name in ipairs(always_hidden_names) do
          if name == always_hidden_name then
            return true
          end
        end

        local always_hidden_name_starts = {
          ".null-ls_",
        }
        for _, always_hidden_name_start in ipairs(always_hidden_name_starts) do
          if vim.startswith(name, always_hidden_name_start) then
            return true
          end
        end
      end,
    },
  },
}
