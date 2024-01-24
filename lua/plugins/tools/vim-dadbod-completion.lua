-- vim-dadbod-completion
--
-- Database auto completion powered by vim-dadbod.

return {
  "kristijanhusak/vim-dadbod-completion",
  dependencies = {
    "tpope/vim-dadbod",
    "hrsh7th/nvim-cmp",
  },
  ft = { "sql", "mysql", "plsql" },
  config = function()
    vim.api.nvim_command(
      "autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })"
    )
  end,
}
