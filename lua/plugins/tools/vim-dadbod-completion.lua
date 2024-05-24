-- vim-dadbod-completion
--
-- Plugin providing database auto-completion powered by vim-dadbod.

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
