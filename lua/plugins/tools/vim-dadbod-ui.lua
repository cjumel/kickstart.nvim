-- vim-dadbod-ui
--
-- Simple UI for vim-dadbod. It allows simple navigation through databases and saving queries for later use.

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
  },
  keys = { {
    "<leader>ad",
    "<cmd>DBUIToggle<CR>",
    desc = "[A]ctions: [D]atabase explorer",
  } },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
  end,
}
