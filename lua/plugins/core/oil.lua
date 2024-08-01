-- oil.nvim
--
-- Oil is a modern version of netwrc, Vim's default file explorer, which lets you edit your file system just like any
-- Neovim buffer. It is my plugin of choice for file edition, as it is a powerful alternative to tree explorers,
-- focusing on the current directory in a single window, instead of the whole project tree in a side window. The file
-- editing features it provides are very elegant and natural to learn, and they are usable with other plugins, like
-- Copilot.vim or code snippest (e.g. Luasnip), which makes creating files very simple & customizable.

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- Required to be used as default file explorer
  keys = { { "-", function() require("oil").open() end, desc = "Open parent directory" } },
  opts = {
    win_options = { number = false, relativenumber = false }, -- Disable line-numbering in Oil buffers
    cleanup_delay_ms = 0, -- Cleanup the oil buffer right away to avoid jumping back to it with <C-o> and <C-i>
    keymaps = {
      -- Since Oil can be used as an actual editable buffer, to edit files quickly and optionally in batch, let's not
      --  overwrite any keymap which could be useful for editing files, to still be able to use features like macros
      --  (with "q"), visual block edition (with "<C-v>") or decrementing (with "<C-x>") for instance

      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["<CR>"] = "actions.select",
      ["<C-c>"] = "actions.close",
      ["<C-]>"] = "actions.preview",
      ["g?"] = "actions.show_help",

      ["<localleader>x"] = { "actions.select", opts = { horizontal = true }, desc = "Open entry in split" },
      ["<localleader>v"] = { "actions.select", opts = { vertical = true }, desc = "Open entry in vertical split" },
      ["<localleader>t"] = { "actions.select", opts = { tab = true }, desc = "Open entry in new tab" },
      ["<localleader>h"] = "actions.toggle_hidden",
      ["<localleader>r"] = "actions.refresh",
      ["<localleader>s"] = "actions.change_sort",
      ["<localleader>d"] = { -- Taken from Oil recipes
        callback = function()
          DETAIL = not DETAIL
          if DETAIL then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
        desc = "Toggle file detail view",
      },
    },
    use_default_keymaps = false,
    view_options = {
      is_hidden_file = function(name, _)
        if name == "__pycache__" then -- Make Python cache files considered as hidden
          return true
        end
        return vim.startswith(name, ".") -- Default condition
      end,
      is_always_hidden = function(name, _) return name == ".." end, -- Don't show ".." when showing hidden files
    },
  },
}
