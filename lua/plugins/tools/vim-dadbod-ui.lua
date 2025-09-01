return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
  },
  cmd = {
    "DBUI",
    "DBUIClose",
    "DBUIToggle",
    "DBUIFindBuffer",
    "DBUIRenameBuffer",
    "DBUIAddConnection",
    "DBUILastQueryInfo",
  },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_disable_mappings_sql = 1 -- Use custom keymaps defined below
  end,
}
