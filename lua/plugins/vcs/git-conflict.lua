-- git-conflict.nvim
--
-- A plugin to visualise and resolve merge conflicts in Neovim.

return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre" },
  opts = {
    default_mappings = false, -- Keymaps are implemented in Hydra.nvim and nvim-treesitter-textobjects
    disable_diagnostics = true,
  },
}
