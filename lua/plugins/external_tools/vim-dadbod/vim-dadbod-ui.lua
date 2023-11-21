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
      "<leader>DD",
      function()
        vim.cmd("DBUIToggle")
      end,
      desc = "[D]atabase: toggle UI",
    },
  },
}
