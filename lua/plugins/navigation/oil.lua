-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

local custom_actions = {}

-- Overwrite the default preview action to open the preview window on the right hand side
custom_actions.preview = {
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
}

-- Overwrite Harpoon keymap to add the file under the cursor in Oil buffer instead
-- of Oil buffer itself
custom_actions.add_harpoon_mark = {
  desc = "Hook with Harpoon",
  callback = function()
    local entry = require("oil").get_cursor_entry()
    if entry == nil then
      return
    end
    local dir = require("oil").get_current_dir()
    local path = dir .. entry.name
    require("plugins.navigation.harpoon.utils.actions").add_mark(path)
  end,
}

local is_hidden_file = function(name, _)
  return (name ~= "..") and vim.startswith(name, ".")
end

local is_always_hidden = function(name, _)
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
end

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
      function()
        require("oil").open()
      end,
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
      ["<tab>"] = custom_actions.preview,
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["R"] = "actions.refresh",
      ["?"] = "actions.show_help",
      ["<leader>h"] = custom_actions.add_harpoon_mark,
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = is_hidden_file,
      is_always_hidden = is_always_hidden,
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Disable line numbers and column ruler in Oil buffer
    vim.api.nvim_command("autocmd FileType oil setlocal nonumber")
    vim.api.nvim_command("autocmd FileType oil setlocal norelativenumber")
    vim.api.nvim_command("autocmd FileType oil setlocal colorcolumn=")
  end,
}
