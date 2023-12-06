-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

local add_harpoon_mark_from_oil = function()
  local entry = require("oil").get_cursor_entry()
  if entry == nil then
    return
  end
  local dir = require("oil").get_current_dir()
  local path = dir .. entry.name
  require("plugins.navigation.harpoon.custom.actions").add_mark(path)
end

local is_hidden = function(name, _)
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
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "ThePrimeagen/harpoon",
  },
  -- To use oil as default file explorer, it must not be lazy loaded or with VeryLazy event
  lazy = false,
  keys = {
    {
      "-",
      function()
        require("oil").open_float()
      end,
      desc = "[-] Open parent directory",
    },
  },
  opts = {
    win_options = {
      signcolumn = "yes",
    },
    -- Cleanup the oil buffer right away to avoid jumping back to it with <C-o> and <C-i>
    cleanup_delay_ms = 0,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      -- Using <tab> will break <C-i> to jump forward in the jump list as they are the same key
      ["<ESC>"] = "actions.close",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["H"] = "actions.toggle_hidden",
      ["R"] = "actions.refresh",
      -- Overwrite Harpoon keymap to add the file under the cursor in Oil buffer instead
      -- of Oil buffer itself
      ["<leader><CR>"] = add_harpoon_mark_from_oil,
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = is_hidden,
      is_always_hidden = is_always_hidden,
    },
    float = {
      max_width = 80,
      max_height = 20,
      border = "single",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Disable line numbers and column ruler in Oil buffer
    vim.api.nvim_command("autocmd FileType oil setlocal nonumber")
    vim.api.nvim_command("autocmd FileType oil setlocal colorcolumn=")
  end,
}
