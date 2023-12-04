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
  keys = {
    {
      "<leader>s",
      function()
        vim.cmd("DBUIToggle")
      end,
      desc = "[S]QL UI toggle",
    },
  },
}
