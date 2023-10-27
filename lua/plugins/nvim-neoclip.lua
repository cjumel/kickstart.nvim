-- neoclip
--
-- neoclip is a clipboard manager for neovim inspired for example by clipmenu.

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>p",
      function()
        local opts = require("telescope.themes").get_dropdown({
          initial_mode = "normal",
          layout_config = {
            mirror = true, -- make the preview below the prompt and results
            width = 0.7, -- just enough for the content spec column
          },
        })
        require("telescope").extensions.neoclip.default(opts)
      end,
      desc = "[P]aste from history",
    },
    {
      "<leader>P",
      function()
        require("neoclip").clear_history()
      end,
      desc = "Clear [P]aste history",
    },
  },
  opts = {
    history = 25,
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
          select = "<cr>",
        },
        n = {
          select = "<cr>",
          paste = "p",
          paste_behind = "P",
          delete = "dd",
        },
      },
    },
  },
}
