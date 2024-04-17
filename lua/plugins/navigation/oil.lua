-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  -- To use oil as default file explorer, it must not be lazy loaded or with VeryLazy event
  lazy = false,
  keys = {
    {
      "-",
      function() require("oil").open() end,
      desc = "Open Oil buffer",
    },
  },
  opts = {
    win_options = {
      signcolumn = "yes",
    },
    -- Cleanup the oil buffer right away to avoid jumping back to it with <C-o> and <C-i>
    cleanup_delay_ms = 0,
    keymaps = {
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["R"] = "actions.refresh",
      ["?"] = "actions.show_help",
      -- Custom actions
      -- Overwrite the default preview action to open the preview window on the right hand side
      ["<C-i>"] = {
        desc = "Open the entry under the cursor in a preview window, or close the preview window if already open",
        callback = function()
          local oil = require("oil")
          local util = require("oil.util")
          local entry = oil.get_cursor_entry()
          if not entry then
            vim.notify("Could not find entry under cursor", vim.log.levels.ERROR)
            return
          end
          local winid = util.get_preview_win()
          if winid then
            local cur_id = vim.w[winid].oil_entry_id
            if entry.id == cur_id then
              vim.api.nvim_win_close(winid, true)
              return
            end
          end
          oil.select({ preview = true, split = "belowright" }) -- Open on the right hand side
        end,
      },
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, _)
        -- Add some stuff globally git-ignored but not hidden
        if name == "__pycache__" then -- Python cache files
          return true
        end

        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, _)
        -- Displaying ".." doesn't bring neither new information nor features
        if name == ".." then
          return true
        end

        -- Don't display Neovim-related files
        if vim.startswith(name, ".null-ls_") then -- Null-ls temporary files
          return true
        end

        return false
      end,
    },
  },
}
