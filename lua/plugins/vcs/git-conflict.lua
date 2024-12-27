-- git-conflict.nvim
--
-- A plugin to visualise and resolve merge conflicts in Neovim.

return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre" },
  opts = {
    default_mappings = false, -- Keymaps are implemented in the Git conflict Hydra
    disable_diagnostics = true,
  },
}
