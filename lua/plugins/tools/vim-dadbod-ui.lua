-- vim-dadbod-ui
--
-- Simple UI for vim-dadbod. It allows simple navigation through databases and allows saving
-- queries for later use.

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
  },
  cmd = {
    "DBUIToggle",
  },
  config = function() vim.g.db_ui_use_nvim_notify = 1 end,
}
