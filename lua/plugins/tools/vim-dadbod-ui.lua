-- vim-dadbod-ui
--
-- Simple UI for vim-dadbod. It allows simple navigation through databases and allows saving queries for later use.

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
  },
  keys = { { "<leader>-", "<cmd>DBUIToggle<CR>", desc = "Database explorer" } },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_disable_mappings_sql = 1 -- Use custom keymaps defined below
  end,
}
