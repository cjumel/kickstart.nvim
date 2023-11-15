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
  config = function()
    local custom_actions = require("plugins.navigation.oil.custom.actions")
    local custom_opts = require("plugins.navigation.oil.custom.opts")

    require("oil").setup({
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
        ["<tab>"] = "actions.preview",
        ["<ESC>"] = "actions.close",
        ["q"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["H"] = "actions.toggle_hidden",
        ["R"] = "actions.refresh",
        -- Overwrite Harpoon keymap to add the file under the cursor in Oil buffer instead
        -- of Oil buffer itself
        ["<leader><CR>"] = custom_actions.add_harpoon_mark_from_oil,
      },
      use_default_keymaps = false,
      view_options = {
        show_hidden = false,
        is_hidden_file = custom_opts.is_hidden,
        is_always_hidden = custom_opts.is_always_hidden,
      },
      float = {
        max_width = 80,
        max_height = 20,
        border = "single",
      },
    })

    -- Disable line numbers and column ruler in Oil buffer
    vim.api.nvim_command("autocmd FileType oil setlocal nonumber")
    vim.api.nvim_command("autocmd FileType oil setlocal colorcolumn=")
  end,
}
