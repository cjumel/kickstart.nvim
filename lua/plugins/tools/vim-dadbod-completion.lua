-- vim-dadbod-completion
--
-- Plugin providing database auto-completion powered by vim-dadbod. It allows to use database aware completion directly
-- in completion plugins, like nvim-cmp, which is very convenient when writting SQL queries.

return {
  "kristijanhusak/vim-dadbod-completion",
  dependencies = {
    "tpope/vim-dadbod",
    "hrsh7th/nvim-cmp",
  },
  ft = { "sql" },
  config = function()
    local cmp = require("cmp")

    cmp.setup.filetype("sql", {
      sources = {
        { name = "vim-dadbod-completion", priority = 10 },
        { name = "buffer" },
      },
    })
  end,
}
