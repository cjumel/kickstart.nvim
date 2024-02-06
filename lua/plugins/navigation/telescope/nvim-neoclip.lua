-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "kkharji/sqlite.lua", module = "sqlite" }, -- For persistent history
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "nvim-telescope/telescope.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>fp",
      function()
        require("telescope").extensions.neoclip.default({
          initial_mode = "normal",
          layout_strategy = "vertical",
        })
      end,
      desc = "[F]ind: [P]aste history",
    },
    {
      "<leader>fm",
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        require("telescope").extensions.macroscope.default(opts)
      end,
      desc = "[F]ind: [M]acro history",
    },
  },
  opts = {
    enable_persistent_history = true,
    content_spec_column = true,
    on_select = {
      move_to_front = true,
    },
    on_paste = {
      set_reg = true,
      move_to_front = true,
    },
    on_replay = {
      set_reg = true,
      move_to_front = true,
    },
    -- Don't store pure whitespace yanks
    filter = require("plugins.navigation.telescope.custom.filters").whitespace_yank_filter_fn,
  },
}
