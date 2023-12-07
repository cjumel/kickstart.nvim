-- undotree
--
-- The undo history visualizer for VIM.

return {
  "mbbill/undotree",
  keys = {
    {
      "<leader>u",
      function()
        vim.cmd("UndotreeToggle")
      end,
      desc = "[U]ndo tree",
    },
  },
  config = function()
    vim.g.undotree_WindowLayout = 3 -- Window on the right of the screen
  end,
}
