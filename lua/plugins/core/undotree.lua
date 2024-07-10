-- undotree
--
-- undotree is a plugin providing a simple but powerfull undo history visualizer for Vim and Neovim. It is very simple
-- of use and provide a convenient interface to visualize the undo tree, visualize different branches and restore
-- any past state, even those unacessible by simple undo/redo actions.

return {
  "mbbill/undotree",
  keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "[U]ndotree" } },
  config = function()
    vim.g.undotree_WindowLayout = 3 -- Window on the right of the screen
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus the undotree window when toggling it
  end,
}
