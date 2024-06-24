-- oil.nvim
--
-- Oil is a modern version of netwrc (vim's default file explorer) which lets you edit your file system just like any
-- in a Neovim buffer. It is my plugin of choice for file edition, as it is a powerful alternative to tree explorers,
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
      ["<C-]>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["g<C-x>"] = "actions.select_split",
      ["g<C-v>"] = "actions.select_vsplit",
      ["g<C-t>"] = "actions.select_tab",
      ["g<C-r>"] = "actions.refresh",
      ["g<C-h>"] = "actions.toggle_hidden",
      ["?"] = "actions.show_help",
    },
    use_default_keymaps = false,
    view_options = {
      is_hidden_file = function(name, _)
        if name == "__pycache__" then -- Make Python cache files considered as hidden
          return true
        end
        return vim.startswith(name, ".") -- Default condition
      end,
      is_always_hidden = function(name, _) return name == ".." end, -- Don't show ".." when hidden is on
    },
  },
}
