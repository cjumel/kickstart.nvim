-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = true,
  opts = {
    default_file_explorer = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["="] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["R"] = "actions.refresh",
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
  init = function()
    vim.keymap.set("n", "-", function()
      require("oil").open()
    end, { desc = "[-] Open Parent Directory" })
  end,
}
