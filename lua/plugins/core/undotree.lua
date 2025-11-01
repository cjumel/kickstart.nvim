return {
  "mbbill/undotree",
  keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "[U]ndotree" } },
  config = function()
    vim.g.undotree_WindowLayout = 3 -- Window on the right-hand-side
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus the undotree window when toggled
  end,
}
