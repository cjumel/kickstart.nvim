return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- Required to be used as default file explorer
  keys = {
    { "-", function() require("oil").open() end, desc = "Open parent directory" },
    { "g-", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open current working directory" },
  },
  opts = {
    win_options = { number = false, relativenumber = false },
    cleanup_delay_ms = 0, -- Cleanup the Oil buffer right away to avoid jumping back to it with <C-o>
    lsp_file_methods = {
      timeout_ms = 5000, -- Increase duration to avoid time-outs
      autosave_changes = true,
    },
    keymaps = {
      -- Let's not overwrite any keymap which could be useful to edit files
      ["-"] = "actions.parent",
      ["<CR>"] = "actions.select",
      ["gx"] = "actions.open_external",
      ["<C-c>"] = "actions.close",
      ["<localleader>d"] = {
        function() -- Function taken from Oil recipes
          DETAIL = not DETAIL
          if DETAIL then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
        desc = "Toggle [D]etails",
      },
      ["<localleader>h"] = { "actions.toggle_hidden", desc = "Toggle [H]idden files" },
      ["<localleader>p"] = { "actions.preview", desc = "Toggle [P]review" },
      ["<localleader>r"] = { "actions.refresh", desc = "[R]efresh" },
    },
    use_default_keymaps = false,
    view_options = {
      is_always_hidden = function(name, _) return name == ".." end,
      case_insensitive = true,
    },
  },
}
