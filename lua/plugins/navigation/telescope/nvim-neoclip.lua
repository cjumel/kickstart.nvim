-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "nvim-telescope/telescope.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>p",
      function()
        require("telescope").extensions.neoclip.default({
          layout_strategy = "vertical",
          initial_mode = "normal",
        })
      end,
      mode = { "n", "v" },
      desc = "[P]aste from history",
    },
    {
      "<leader>P",
      function()
        require("neoclip").clear_history()
      end,
      mode = { "n", "v" },
      desc = "Clear [P]aste history",
    },
  },
  opts = {
    content_spec_column = true,
    on_select = {
      move_to_front = true,
    },
    on_paste = {
      set_reg = true,
      move_to_front = true,
    },
    keys = {
      telescope = {
        i = {
          select = "<CR>",
        },
        n = {
          select = "<CR>",
          paste = "p",
          paste_behind = "P",
          delete = "d",
        },
      },
    },
    -- Don't store pure whitespace yanks
    filter = require("plugins.navigation.telescope.utils.filters").whitespace_yank_filter_fn,
  },
}
