-- vim-dadbod-ui
--
-- Plugin providing a simple UI for vim-dadbod, allowing simple navigation through databases and saving queries for
-- later use. This plugin makes Neovim suited to explore databases like an actual database explorer.

-- NOTE: to interact with a PostgreSQL database, `psql`, the Postgres interactive terminal, must be installed as well
-- for instance with `brew install postgresql@14`

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_disable_mappings_sql = 1 -- Use custom keymaps defined below

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sql",
      group = vim.api.nvim_create_augroup("DBUIKeymaps", { clear = true }),
      callback = function()
        vim.keymap.set("n", "<localleader>s", "<Plug>(DBUI_SaveQuery)", { desc = "Save query", buffer = true })
      end,
    })
  end,
}
