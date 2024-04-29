-- oil.nvim
--
-- A netwrc-like file explorer that lets you edit your file system like a regular Neovim buffer.
--
-- Oil is my plugin of choice for file navigation. It's a powerful alternative to tree explorers, focusing on the
-- current directory in a single window, instead of the whole project tree in a side window. The file editing features
-- it provides are very elegant and natural to learn, and they are usable with regular edition plugins like Copilot.vim
-- or nvim-cmp with Luasnip, which makes creating files customizable & very simple.

return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false, -- Required to be used as default file explorer
  keys = {
    { "-", function() require("oil").open() end, desc = "Open parent directory" },
  },
  opts = {
    win_options = { signcolumn = "yes" }, -- Add an empty column, improving the look of the Oil buffer
    cleanup_delay_ms = 0, -- Cleanup the oil buffer right away to avoid jumping back to it with <C-o> and <C-i>
    keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-i>"] = "actions.preview",
      ["q"] = "actions.close",
      ["R"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
    view_options = {
      is_hidden_file = function(name, _)
        if name == "__pycache__" then -- Python cache files
          return true
        end
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, _) return name == ".." end,
    },
  },
}
