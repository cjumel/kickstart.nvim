-- oil.nvim
--
-- Enable netwrc-style file navigation in buffers.
-- Additionally, this plugin supports editing files like editing a buffer (renaming, writing, etc.)

local custom_actions = require("plugins.navigation.oil.actions")
local custom_opts = require("plugins.navigation.oil.opts")

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
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = custom_opts.is_hidden_file,
      is_always_hidden = custom_opts.is_always_hidden,
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
